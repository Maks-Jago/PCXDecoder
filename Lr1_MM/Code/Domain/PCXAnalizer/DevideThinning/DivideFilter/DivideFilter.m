//
//  DivideFilter.m
//  Lr1_MM
//
//  Created by Max Kuznetsov on 11.01.14.
//  Copyright (c) 2014 111Minutes. All rights reserved.
//

#import "DivideFilter.h"

@implementation DivideFilter

+ (void)filterDivide:(CGRect)divide
         withPallete:(NSMutableArray *)pallete
          blackIndex:(NSUInteger)blackIndex
          whiteIndex:(NSUInteger)whiteIndex
{
    for (int i = divide.origin.y; i < divide.size.height + divide.origin.y; i++) {
        for (int j = divide.origin.x; j < divide.size.width + divide.origin.x; j++) {
            NSUInteger value = [pallete[i][0][j] unsignedIntegerValue];
            
            if (value != blackIndex && value != kSaveValue) {
                continue;
            }
            
            NSUInteger topLeft = whiteIndex;
            NSUInteger topCenter = whiteIndex;
            NSUInteger topRight = whiteIndex;
            
            if (j - 1 > 0 && i - 1 > 0) {
                topLeft = [pallete[i - 1][0][j - 1] unsignedIntegerValue];
                topCenter = [pallete[i - 1][0][j] unsignedIntegerValue];
                topRight = [pallete[i - 1][0][j + 1] unsignedIntegerValue];
            }
            
            NSUInteger midleLeft = whiteIndex;
            NSUInteger bottomLeft = whiteIndex;
            
            if (j - 1 > 0) {
                midleLeft = [pallete[i][0][j - 1] unsignedIntegerValue];
                bottomLeft = [pallete[i + 1][0][j - 1] unsignedIntegerValue];
            }
            
            
            NSUInteger midleRight = [pallete[i][0][j + 1] unsignedIntegerValue];
            
            NSUInteger bottomCenter = [pallete[i + 1][0][j] unsignedIntegerValue];
            NSUInteger bottomRight = [pallete[i + 1][0][j + 1] unsignedIntegerValue];
            
            midleLeft = [self convertValue:midleLeft blackIndex:blackIndex];
            midleRight = [self convertValue:midleRight blackIndex:blackIndex];
            
            topLeft = [self convertValue:topLeft blackIndex:blackIndex];
            topRight = [self convertValue:topRight blackIndex:blackIndex];
            topCenter = [self convertValue:topCenter blackIndex:blackIndex];
            
            bottomCenter = [self convertValue:bottomCenter blackIndex:blackIndex];
            bottomLeft = [self convertValue:bottomLeft blackIndex:blackIndex];
            bottomRight = [self convertValue:bottomRight blackIndex:blackIndex];
            
            
            /*
             0 0 1
             0 1 0
             1 0 0
             */
            if (midleLeft == whiteIndex && midleRight == whiteIndex  &&
                topLeft == whiteIndex && (topCenter == whiteIndex || topCenter == kEraseIndex) && (topRight == whiteIndex || topRight == kEraseIndex) &&
                (bottomLeft == blackIndex || topRight == kEraseIndex) && bottomCenter == whiteIndex  && bottomRight == whiteIndex) {
                [pallete[i][0] replaceObjectAtIndex:j withObject:[NSNumber numberWithInteger:kEraseIndex]];
            }
        }
    }
}

+ (NSUInteger)convertValue:(NSUInteger)value blackIndex:(NSUInteger)blackIndex
{
    if (value == kSaveValue || value == 774) {
        return blackIndex;
    }
    return value;
}


@end
