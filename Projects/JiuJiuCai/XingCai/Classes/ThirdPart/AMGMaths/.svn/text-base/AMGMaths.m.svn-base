//
//  AMGMaths.m
//  AMGMaths
//
//  Created by Albert Mata on 04/04/2013.
//  Copyright (c) 2013 Albert Mata. All rights reserved.
//

#import "AMGMaths.h"

@implementation AMGMaths

+ (unsigned long long)maximumCalculatedWithNaturalNumbers:(NSArray *)numbers
{
    int ones = 0, twos = 0;
    for(NSNumber *n in numbers) {
        if ([n isEqual:@1]) ones++;
        if ([n isEqual:@2]) twos++;
    }
    
    NSMutableArray *temp = [numbers mutableCopy];
    if (ones > 0) {
        [temp removeObject:@1];
        [temp removeObject:@2];
        
        int extra = twos * 2 + ones;
        for (; extra > 2 && extra != 4; extra -= 3) [temp addObject:@3];
        
        if (1 == extra) {
            int lowest = 0, lowestIndex = -1, i = 0;
            for (NSNumber *n in temp) {
                if (0 == lowest || [n intValue] < lowest) {
                    lowest = [n intValue];
                    lowestIndex = i;
                    i++;
                }
            }
            if (lowestIndex > -1) [temp removeObjectAtIndex:lowestIndex];
            [temp addObject:@(lowest + extra)];
        } else if (2 == extra || 4 == extra) {
            [temp addObject:@(extra)];
        }
    }
    
    unsigned long long allMultiplied = 1;
    for (NSNumber *n in temp) allMultiplied *= [n intValue];
    return allMultiplied;
}

+ (double)meanOfNumbers:(NSArray *)array
{
    double runningTotal = 0.0;
    
    for(NSNumber *number in array) {
        runningTotal += [number doubleValue];
    }
    
    return (runningTotal / [array count]);
}

+ (double)standardDeviationOfNumbers:(NSArray *)array
{
    if ([array count] == 0) return 0.0;
    
    double mean = [self meanOfNumbers:array];
    double sumOfSquaredDifferences = 0.0;
    
    for(NSNumber *number in array) {
        double difference = [number doubleValue] - mean;
        sumOfSquaredDifferences += difference * difference;
    }
    
    return sqrt(sumOfSquaredDifferences / [array count]);
}

@end