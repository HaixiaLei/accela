//
//  AMGCombinatorics.m
//  AMGMaths
//
//  Created by Albert Mata on 10/04/2013.
//  Copyright (c) 2013 Albert Mata. All rights reserved.
//

#import "AMGCombinatorics.h"

@implementation AMGCombinatorics

+ (NSSet *)permutationsWithoutRepetitionFromElements:(NSArray *)elements taking:(int)number
{
    return [NSSet setWithArray:[self permWithoutRepFrom:elements taking:number]];
}

+ (NSSet *)permutationsWithRepetitionFromElements:(NSArray *)elements taking:(int)number
{
    return [NSSet setWithArray:[self permWithRepFrom:elements taking:number]];
}

+ (NSSet *)combinationsWithoutRepetitionFromElements:(NSArray *)elements taking:(int)number
{
    return [NSSet setWithArray:[self combWithoutRepFrom:elements taking:number]];
}

+ (NSSet *)combinationsWithRepetitionFromElements:(NSArray *)elements taking:(int)number
{
    return [NSSet setWithArray:[self combWithRepFrom:elements taking:number]];
}

+ (NSArray *)permWithoutRepFrom:(NSArray *)elements taking:(int)number
{
    NSMutableArray *container = [NSMutableArray new];
    
    if (number == 1 && [elements count] > 0) {
        
        container = [self addArraysWithElements:elements toContainer:container];
        
    } else if (number > 1 && [elements count] > 0) {
        
        for (int i = 0; i < [elements count]; i++) {
            id element = elements[i];
            NSMutableArray *temp = [elements mutableCopy];
            [temp removeObjectAtIndex:i];
            for (NSArray *array in [self permWithoutRepFrom:temp taking:number - 1]) {
                container = [self addArrayByJoiningElement:element andArray:array toContainer:container];
            }
        }
        
    }
    
    return container;
}

+ (NSArray *)permWithRepFrom:(NSArray *)elements taking:(int)number
{
    NSMutableArray *container = [NSMutableArray new];
    
    if (number == 1 && [elements count] > 0) {
        
        container = [self addArraysWithElements:elements toContainer:container];
        
    } else if (number > 1 && [elements count] > 0) {
        
        for (id element in elements) {
            for (NSArray *array in [self permWithRepFrom:elements taking:number - 1]) {
                container = [self addArrayByJoiningElement:element andArray:array toContainer:container];
            }
        }
        
    }
    
    return container;
}

+ (NSArray *)combWithoutRepFrom:(NSArray *)elements taking:(int)number
{
    NSMutableArray *container = [NSMutableArray new];
    
    if (number == 1 && [elements count] > 0) {
        
        container = [self addArraysWithElements:elements toContainer:container];
        
    } else if (number > 1 && [elements count] > 0) {
        
        for (int i = 0; i < [elements count] - 1; i++) {
            id element = elements[i];
            NSMutableArray *temp = [self arrayWithArray:elements fromIndex:i + 1];
            for (NSArray *array in [self combWithoutRepFrom:temp taking:number - 1]) {
                container = [self addArrayByJoiningElement:element andArray:array toContainer:container];
            }
        }
        
    }
    
    return container;
}

+ (NSArray *)combWithRepFrom:(NSArray *)elements taking:(int)number
{
    NSMutableArray *container = [NSMutableArray new];
    
    if (number == 1 && [elements count] > 0) {
        
        container = [self addArraysWithElements:elements toContainer:container];
        
    } else if (number > 1 && [elements count] > 0) {
        
        for (int i = 0; i < [elements count]; i++) {
            id element = elements[i];
            NSMutableArray *temp = [self arrayWithArray:elements fromIndex:i];
            for (NSArray *array in [self combWithRepFrom:temp taking:number - 1]) {
                container = [self addArrayByJoiningElement:element andArray:array toContainer:container];
            }
        }
        
    }
    
    return container;
}

+ (NSMutableArray *)arrayWithArray:(NSArray *)array fromIndex:(int)index
{
    return [[array objectsAtIndexes:
             [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, [array count] - index)]]
            mutableCopy];
}

+ (NSMutableArray *)addArraysWithElements:(NSArray *)elements toContainer:(NSMutableArray *)container
{
    for (id elem in elements) {
        [container addObject:@[elem]];
    }
    return container;
}

+ (NSMutableArray *)addArrayByJoiningElement:(id)element andArray:(NSArray *)array toContainer:(NSMutableArray *)container
{
    NSMutableArray *new = [array mutableCopy];
    [new insertObject:element atIndex:0];
    [container addObject:new];
    return container;
}

@end