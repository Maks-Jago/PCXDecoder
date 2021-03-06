//
//  Defines.m
//  Lr1_MM
//
//  Created by Max Kuznetsov on 22.10.13.
//  Copyright (c) 2013 111Minutes. All rights reserved.
//

#import "Defines.h"

NSUInteger UIIntegerFromBytes(Byte firstByte, Byte secondByte)
{
    return [[NSString stringWithFormat:@"%d%d", secondByte, firstByte] integerValue];
}

NSUInteger RoundFloat(CGFloat floatValue)
{
    NSUInteger roundedValue = (NSUInteger)floatValue;
    if ((CGFloat)roundedValue - floatValue >= 0.7) {
        roundedValue++;
    }
    return roundedValue;
}