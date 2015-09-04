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

static NSString * const AppCacheManagerMenuAndRuleKey = @"AppCacheManagerMenuAndRuleKey";
static NSString * const AppCacheFolderName = @"AppCaches";
static NSString * const AppCacheFileName = @"Caches.plist";

@interface AppCacheManager()
@property (nonatomic, copy) void (^completionBlock)(NSError *error);
@end

@implementation AppCacheManager
{
    NSMutableDictionary *menuAndRuleErrors;
    NSMutableArray *kindOfLotteries;
}

+ (AppCacheManager *)sharedManager {
    static AppCacheManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[AppCacheManager alloc] init];
    });
    
    return _sharedManager;
}

+ (NSString *)getMenuAndRuleKeyNameWithKindOfLottery:(KindOfLottery *)kindOfLottery
{
    NSString *menuAndRuleKeyName = [NSString stringWithFormat:@"%@_%@_%@_%@",AppCacheManagerMenuAndRuleKey,kindOfLottery.nav,kindOfLottery.curmid,kindOfLottery.pid];
    return menuAndRuleKeyName;
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

- (void)updateLotteryListWithBlock:(void (^)())complete
{
    [[AppHttpManager sharedManager] lotteryListWithBlock:^(id JSON, NSError *error){
        if (!error) {
            if ([JSON isKindOfClass:[NSArray class]]) {
                kindOfLotteries = [NSMutableArray array];
                for (NSDictionary *dictionary in JSON) {
                    KindOfLottery *kindOfLottery = [[KindOfLottery alloc] initWithDictionary:dictionary];
                    [kindOfLotteries addObject:kindOfLottery];
                }
                
                //更新玩法
                self.completionBlock = complete;
                [self updatePlayRulesAtIndex:0];
            }
            else
            {
                DDLogWarn(@"lotteryList should be NSArray");
            }
        }
        else
        {
            DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,(long)error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
            
            if (complete) {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Error from AppCacheManager" forKey:NSLocalizedFailureReasonErrorKey];
                NSError *theError = [[NSError alloc] initWithDomain:AppCacheManagerErrorDomain code:error.code userInfo:userInfo];
                complete(theError);
            }
        }
    }];
}

- (NSArray *)getLotteryList
{
    return kindOfLotteries;
}

- (NSArray *)getMenuAndRuleWithKindOfLottery:(KindOfLottery *)kindOfLottery
{
    id JSON = [self getValueForKey:[AppCacheManager getMenuAndRuleKeyNameWithKindOfLottery:kindOfLottery]];
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

- (void)savePlayRulesJSON:(id)playRulesJSON kindOfLottery:(KindOfLottery *)kindOfLottery
{
    [self setValue:playRulesJSON forKey:[AppCacheManager getMenuAndRuleKeyNameWithKindOfLottery:kindOfLottery]];
}

- (void)updatePlayRulesAtIndex:(NSInteger)index
{
    if (index >= kindOfLotteries.count) {
        if (self.completionBlock) {
            self.completionBlock(nil);
        }
        return;
    }
    
    for (KindOfLottery *kindOfLottery in kindOfLotteries) {
        NSLog(@"name = %@",kindOfLottery.cnname);
    }
    
    KindOfLottery *kindOfLottery = [kindOfLotteries objectAtIndex:index];
    
    NSInteger nextIndex = index + 1;

    [[AppHttpManager sharedManager] menuAndRuleMethodWithKind:kindOfLottery Block:^(id JSON, NSError *error){
        if (!error) {
            [self savePlayRulesJSON:JSON kindOfLottery:kindOfLottery];
        }
        else
        {
            [self savePlayRulesJSON:nil kindOfLottery:kindOfLottery];
            if ([JSON isKindOfClass:[NSDictionary class]] && [JSON objectForKey:@"msg"]) {
                [self setErrorMsg:[JSON objectForKey:@"msg"] kindOfLottery:kindOfLottery];
            }
        }
        [self updatePlayRulesAtIndex:nextIndex];
    }];
}

- (void)setErrorMsg:(NSString *)errorMsg kindOfLottery:(KindOfLottery *)kindOfLottery
{
    NSString *key = [AppCacheManager getMenuAndRuleKeyNameWithKindOfLottery:kindOfLottery];
    if (!menuAndRuleErrors) {
        menuAndRuleErrors = [NSMutableDictionary dictionary];
    }
    [menuAndRuleErrors setObject:errorMsg forKey:key];
}

- (NSString *)menuAndRuleErrorMsgWithKindOfLottery:(KindOfLottery *)kindOfLottery
{
    NSString *key = [AppCacheManager getMenuAndRuleKeyNameWithKindOfLottery:kindOfLottery];
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
@end
