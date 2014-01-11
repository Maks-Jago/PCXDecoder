//
//  BlackPixelsCalculator.m
//  Lr1_MM
//
//  Created by Max Kuznetsov on 11.01.14.
//  Copyright (c) 2014 111Minutes. All rights reserved.
//

#import "BlackPixelsCalculator.h"

@implementation BlackPixelsCalculator

+ (NSUInteger)calculateBlackPixelsForPoint:(CGPoint)point
                                withDevide:(CGRect)devide
                                   pallete:(NSMutableArray *)pallete
                                whiteIndex:(NSUInteger)whiteIndex
                                blackIndex:(NSUInteger)blackIndex
{
    NSUInteger blackPixelsCount = 0;
    int i = (int)point.y;
    int j = (int)point.x;
    
    NSUInteger topLeft = whiteIndex;
    NSUInteger topCenter = whiteIndex;
    NSUInteger topRight = whiteIndex;
    if (j - 1 > 0 && i - 1 > 0) {
        topLeft = [pallete[i - 1][0][j - 1] unsignedIntegerValue];
        if (j < [pallete[i - 1][0] count]) {
            topCenter = [pallete[i - 1][0][j] unsignedIntegerValue];
        }
    
        if (j + 1 < [pallete[i - 1][0] count]) {
            topRight = [pallete[i - 1][0][j + 1] unsignedIntegerValue];
        }
    }
    
    NSUInteger midleLeft = whiteIndex;
    NSUInteger bottomLeft = whiteIndex;
    if (j - 1 > 0) {
        midleLeft = [pallete[i][0][j - 1] unsignedIntegerValue];
        
        if (i + 1 < pallete.count) {
            bottomLeft = [pallete[i + 1][0][j - 1] unsignedIntegerValue];
        }
    }
    
    NSUInteger midleRight = whiteIndex;
    if (j + 1 < [pallete[i][0] count]) {
        midleRight = [pallete[i][0][j + 1] unsignedIntegerValue];
    }
    
    
    NSUInteger bottomCenter = whiteIndex;
    NSUInteger bottomRight = whiteIndex;
    
    if (i + 1 < pallete.count) {
        if (j < [pallete[i - 1][0] count]) {
            bottomCenter = [pallete[i + 1][0][j] unsignedIntegerValue];
        }
        
        if (j + 1 < [pallete[i + 1][0] count]) {
            bottomRight = [pallete[i + 1][0][j + 1] unsignedIntegerValue];
        }
    }
    
    blackPixelsCount = [self incrementIndex:blackPixelsCount withValue:topLeft maxValue:blackIndex];
    blackPixelsCount = [self incrementIndex:blackPixelsCount withValue:topCenter maxValue:blackIndex];
    blackPixelsCount = [self incrementIndex:blackPixelsCount withValue:topRight maxValue:blackIndex];
    blackPixelsCount = [self incrementIndex:blackPixelsCount withValue:midleLeft maxValue:blackIndex];
    blackPixelsCount = [self incrementIndex:blackPixelsCount withValue:midleRight maxValue:blackIndex];
    blackPixelsCount = [self incrementIndex:blackPixelsCount withValue:bottomLeft maxValue:blackIndex];
    blackPixelsCount = [self incrementIndex:blackPixelsCount withValue:bottomCenter maxValue:blackIndex];
    blackPixelsCount = [self incrementIndex:blackPixelsCount withValue:bottomRight maxValue:blackIndex];
    return blackPixelsCount;
}

+ (NSUInteger)incrementIndex:(NSUInteger)index withValue:(NSUInteger)value maxValue:(NSUInteger)maxValue
{
    if (value == maxValue) {
        return index + 1;
    }
    return index;
}


@end
