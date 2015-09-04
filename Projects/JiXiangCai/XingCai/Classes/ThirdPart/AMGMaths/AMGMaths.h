//
//  AMGMaths.h
//  AMGMaths
//
//  Created by Albert Mata on 04/04/2013.
//  Copyright (c) 2013 Albert Mata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMGMaths : NSObject

+ (unsigned long long)maximumCalculatedWithNaturalNumbers:(NSArray *)numbers;
+ (double)meanOfNumbers:(NSArray *)array;
+ (double)standardDeviationOfNumbers:(NSArray *)array;


@end