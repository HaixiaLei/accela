 //
//  AppCacheManager.m
//  XingCai
//
//  Created by jay on 14-1-17.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "AppCacheManager.h"
#import "KindOfLottery.h"
#import "SecondMenuObject.h"
#import "MethodVersionObject.h"

static NSString * const AppCacheFolderName = @"AppCaches";
static NSString * const AppCacheFileName = @"Caches.plist";

static NSString * const lotteryListKey = @"lotteryListKey";
static NSString * const Key_PlayRule = @"Key_PlayRule";
static NSString * const Key_PlayRuleVersion = @"Key_PlayRuleVersion";

@interface AppCacheManager()
@property (nonatomic, copy) void (^completionBlock)(NSError *error);
@end

@implementation AppCacheManager
{
    NSMutableDictionary *menuAndRuleErrors;
    NSArray *lotteryList;
}

+ (AppCacheManager *)sharedManager {
    static AppCacheManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[AppCacheManager alloc] init];
    });
    
    return _sharedManager;
}

- (id)init
{
    if (self = [super init]) {
        NSMutableArray *dataList = [NSMutableArray array];
        KindOfLottery *kindOfLottery = [[KindOfLottery alloc] init];
        kindOfLottery.lotteryName = @"ssc";
        kindOfLottery.lotteryId = @"1";
        kindOfLottery.cnname = @"重庆时时彩";
        [dataList addObject:kindOfLottery];
        kindOfLottery = [[KindOfLottery alloc] init];
        kindOfLottery.lotteryName = @"rbssc";
        kindOfLottery.lotteryId = @"15";
        kindOfLottery.cnname = @"日本时时彩";
        [dataList addObject:kindOfLottery];
        
        lotteryList = dataList;
    }
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    NSMutableDictionary *dictionary = [self dictionary];
    if (!dictionary) {
        dictionary = [NSMutableDictionary dictionary];
    }
    [dictionary setValue:value forKey:key];
    [dictionary writeToFile:[self filePath] atomically:YES];
}
- (id)getValueForKey:(NSString *)key
{
    NSMutableDictionary *dictionary = [self dictionary];
    id value = [dictionary objectForKey:key];
    return value;
}

- (NSString *)filePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];

    NSString *path = [docDir stringByAppendingPathComponent:AppCacheFolderName];
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            DDLogError(@"error:%@",error.localizedDescription);
        }
    }
    path = [path stringByAppendingPathComponent:AppCacheFileName];
    return path;
}

- (NSMutableDictionary *)dictionary
{
    NSMutableDictionary *dictionary = nil;
    if ([self cacheFileExist]) {
        dictionary = [NSMutableDictionary dictionaryWithContentsOfFile:[self filePath]];
    }
    return dictionary;
}
- (BOOL)cacheFileExist
{
    return [[NSFileManager defaultManager] fileExistsAtPath:[self filePath]];
}

- (NSString *)getPlayRuleKeyWithKindOfLottery:(KindOfLottery *)kindOfLottery
{
    NSString *playRuleKey = [NSString stringWithFormat:@"%@_%@",Key_PlayRule,kindOfLottery.lotteryName];
    return playRuleKey;
}

- (NSString *)getPlayRuleVersionKeyWithKindOfLottery:(KindOfLottery *)kindOfLottery
{
    NSString *playRuleVersionKey = [NSString stringWithFormat:@"%@_%@",Key_PlayRuleVersion,kindOfLottery.lotteryName];
    return playRuleVersionKey;
}

- (PlayRulesObject *)getPlayRulesObjectWithKindOfLottery:(KindOfLottery *)kindOfLottery
{
    PlayRulesObject *playRulesObject = nil;
    
    //缓存玩法版本号
    NSString *playRuleCacheVersion = [self getValueForKey:[self getPlayRuleVersionKeyWithKindOfLottery:kindOfLottery]];
    
    if ([playRuleCacheVersion isEqualToString:kindOfLottery.version]) {
        id value = [self getValueForKey:[self getPlayRuleKeyWithKindOfLottery:kindOfLottery]];
        if (value && [value isKindOfClass:[NSDictionary class]]) {
            playRulesObject = [[PlayRulesObject alloc] initWithDictionary:value];
        }
    }
    return playRulesObject;
}

- (void)savePlayRulesJSON:(id)playRulesJSON kindOfLottery:(KindOfLottery *)kindOfLottery
{
    [self setValue:playRulesJSON forKey:[self getPlayRuleKeyWithKindOfLottery:kindOfLottery]];
    [self setValue:kindOfLottery.version forKey:[self getPlayRuleVersionKeyWithKindOfLottery:kindOfLottery]];
}
//- (BOOL)lotteryListExist
//{
//    BOOL exist = NO;
//    
//    NSMutableDictionary *dictionary = [self dictionary];
//    if (dictionary && [[dictionary allKeys] containsObject:lotteryListKey]) {
//        exist = YES;
//    }
//    return exist;
//}

- (void)updateLotteryListWithBlock:(void (^)())complete
{
    [[AppHttpManager sharedManager] lotteryListWithBlock:^(id JSON, NSError *error){
        if (!error) {
            if ([JSON isKindOfClass:[NSArray class]]) {
                [self setValue:JSON forKey:lotteryListKey];
            
                [self updateLotteryAtIndex:0 block:complete];
            }
            else
            {
                DDLogWarn(@"lotteryList should be NSArray");
            }
        }
        else
        {
            DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,(long)error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
            
            [self setValue:nil forKey:lotteryListKey];
            
            if (complete) {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Error from AppCacheManager" forKey:NSLocalizedFailureReasonErrorKey];
                NSError *theError = [[NSError alloc] initWithDomain:AppCacheErrorLotteryListDomain code:error.code userInfo:userInfo];
                complete(theError);
            }
        }
    }];
}

- (NSArray *)getLotteryList
{
    return lotteryList;
}

- (NSArray *)getMenuAndRuleWithKindOfLottery:(KindOfLottery *)kindOfLottery
{
    id JSON = [self getValueForKey:[self getPlayRuleKeyWithKindOfLottery:kindOfLottery]];
   
    NSMutableArray *ruleAndMenuArray = [NSMutableArray array];
    if ([JSON isKindOfClass:[NSArray class]])
    {
        //取2级菜单
        NSArray *allDatas = (NSArray *)JSON;
        for (int i = 0; i < allDatas.count; ++i)
        {
            id object = [allDatas objectAtIndex:i];
            if ([object isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dictionary = (NSDictionary *)object;
                SecondMenuObject *second = [[SecondMenuObject alloc] initWithAttribute:dictionary];
                [ruleAndMenuArray addObject:second];
            }
        }
    }
    
    return ruleAndMenuArray;
}

- (void)updateLotteryAtIndex:(NSInteger)index block:(void (^)())complete
{
//    NSArray *lotteryList = [self getLotteryList];
    
    if (index >= lotteryList.count) {
        if (complete) {
            complete(nil);
        }
        return;
    }
    
    KindOfLottery *kindOfLottery = [lotteryList objectAtIndex:index];
    
//    int nextIndex = index + 1;
    
    //判断是否已经有cache数据
//    if (![self getMenuAndRuleWithKindOfLottery:kindOfLottery]) {
        [[AppHttpManager sharedManager] menuAndRuleMethodWithKind:kindOfLottery Block:^(id JSON, NSError *error){
            if (!error) {
                [self setValue:JSON forKey:[self getPlayRuleKeyWithKindOfLottery:kindOfLottery]];
                
#ifdef Version_1
                [self updateLotteryAtIndex:lotteryList.count block:complete];
#else
                [self updateLotteryAtIndex:nextIndex block:complete];
#endif
            }
            else
            {
                [self setValue:nil forKey:[self getPlayRuleKeyWithKindOfLottery:kindOfLottery]];
                if ([JSON isKindOfClass:[NSDictionary class]] && [JSON objectForKey:@"msg"]) {
                    [self setErrorMsg:[JSON objectForKey:@"msg"] kindOfLottery:kindOfLottery];
                }
                
                if (complete) {
                    DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,(long)error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
                    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Error from AppCacheManager" forKey:NSLocalizedFailureReasonErrorKey];
                    NSError *theError = [[NSError alloc] initWithDomain:AppCacheErrorMenuAndRuleDomain code:error.code userInfo:userInfo];
                    complete(theError);
                }
            }
        }];
//    }
//    else
//    {
//        [self updateLotteryAtIndex:nextIndex block:complete];
//    }
}

- (void)setErrorMsg:(NSString *)errorMsg kindOfLottery:(KindOfLottery *)kindOfLottery
{
    NSString *key = [self getPlayRuleKeyWithKindOfLottery:kindOfLottery];
    if (!menuAndRuleErrors) {
        menuAndRuleErrors = [NSMutableDictionary dictionary];
    }
    [menuAndRuleErrors setObject:errorMsg forKey:key];
}

- (NSString *)menuAndRuleErrorMsgWithKindOfLottery:(KindOfLottery *)kindOfLottery
{
    NSString *key = [self getPlayRuleKeyWithKindOfLottery:kindOfLottery];
    NSString *errorMsg = [menuAndRuleErrors objectForKey:key];
    if (!errorMsg) {
        errorMsg = @"玩法获取失败！";
    }
    return errorMsg;
}

- (void)removeAllMenuAndRuleErrorMsg
{
    [menuAndRuleErrors removeAllObjects];
}

- (void)updateLotteryListWithVersions:(NSArray *)versionList
{
    for (KindOfLottery *kindOfLottery in lotteryList) {
        for (MethodVersionObject *methodVersionObject in versionList)
        {
            if ([methodVersionObject.lotteryname isEqualToString:kindOfLottery.lotteryName]) {
                kindOfLottery.version = methodVersionObject.lastupdate;
                break;
            }
        }
    }
}

- (void)updatePlayRulesWithVersionList:(NSArray *)versionList completionBlock:(void (^)(NSError *error))completionBlock
{
    self.completionBlock = completionBlock;
    [self updateLotteryListWithVersions:versionList];
    [self updatePlayRulesAtIndex:0];
}

- (void)updatePlayRulesWithCompletionBlock:(void (^)(NSError *error))completionBlock
{
    self.completionBlock = completionBlock;
    [self updatePlayRulesAtIndex:0];
}

- (void)updatePlayRulesAtIndex:(NSInteger)index
{
    if (index >= lotteryList.count) {
        if (self.completionBlock) {
            self.completionBlock(nil);
        }
        return;
    }
    
    KindOfLottery *kindOfLottery = [lotteryList objectAtIndex:index];
    
    NSInteger nextIndex = index + 1;
    
    PlayRulesObject *playRulesObject = [self getPlayRulesObjectWithKindOfLottery:kindOfLottery];
    //判断玩法是否已经有cache
    if (!playRulesObject) {
        DDLogInfo(@"##########%@,version:%@ update begin.",kindOfLottery.lotteryName,kindOfLottery.version);
        [[AFAppAPIClient sharedClient] playRules_with_type:kindOfLottery.lotteryName block:^(id JSON, NSError *error){
            if (!error) {
                [self savePlayRulesJSON:JSON kindOfLottery:kindOfLottery];
                DDLogInfo(@"##########%@,version:%@ update finshed.",kindOfLottery.lotteryName,kindOfLottery.version);
            }
            else
            {
                DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,(long)error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
                DDLogInfo(@"##########%@,version:%@ update error:%@.",kindOfLottery.lotteryName,kindOfLottery.version,error.description);
                
                if ([JSON isKindOfClass:[NSDictionary class]] && [JSON objectForKey:@"msg"]) {
                    [self setErrorMsg:[JSON objectForKey:@"msg"] kindOfLottery:kindOfLottery];
                }
                
                if (self.completionBlock) {
                    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Error from AppCacheManager" forKey:NSLocalizedFailureReasonErrorKey];
                    NSError *theError = [[NSError alloc] initWithDomain:AppCacheErrorMenuAndRuleDomain code:error.code userInfo:userInfo];
                    self.completionBlock(theError);
                }
            }
        }];
    }
    else
    {
        DDLogInfo(@"##########%@,version:%@,cache found,skip update.",kindOfLottery.lotteryName,kindOfLottery.version);
    }
    
    [self updatePlayRulesAtIndex:nextIndex];
}
@end
