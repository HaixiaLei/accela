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
static NSString * const AppCacheFolderName = @"AppCaches";
static NSString * const AppCacheFileName = @"Caches.plist";

@implementation AppCacheManager
{
    NSMutableDictionary *menuAndRuleErrors;
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
    NSString *menuAndRuleKeyName = [NSString stringWithFormat:@"%@_%@_%@_%@",menuAndRuleKey,kindOfLottery.nav,kindOfLottery.curmid,kindOfLottery.pid];
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
    id JSON = [self getValueForKey:lotteryListKey];
    
    NSMutableArray *kindOfLotteries = [NSMutableArray array];
    if ([JSON isKindOfClass:[NSArray class]]) {
        NSArray *arryFromJSON = (NSArray *)JSON;
        for (int i = 0; i < arryFromJSON.count; ++i) {
            id oneObject = [arryFromJSON objectAtIndex:i];
            if ([oneObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *oneObjectDictionary = (NSDictionary *)oneObject;
                KindOfLottery *kindOflottery = [[KindOfLottery alloc]initWithAttribute:oneObjectDictionary];
                [kindOfLotteries addObject:kindOflottery];
            }
        }
    }
    
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

- (void)updateLotteryAtIndex:(NSInteger)index block:(void (^)())complete
{
    NSArray *lotteryList = [self getLotteryList];
    
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
                [self setValue:JSON forKey:[AppCacheManager getMenuAndRuleKeyNameWithKindOfLottery:kindOfLottery]];
                
#ifdef Version_1
                [self updateLotteryAtIndex:lotteryList.count block:complete];
#else
                [self updateLotteryAtIndex:nextIndex block:complete];
#endif
            }
            else
            {
                [self setValue:nil forKey:[AppCacheManager getMenuAndRuleKeyNameWithKindOfLottery:kindOfLottery]];
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
