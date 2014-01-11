//
//  MinShapeWidth.m
//  Lr1_MM
//
//  Created by Max Kuznetsov on 11.01.14.
//  Copyright (c) 2014 111Minutes. All rights reserved.
//

#import "MinShapeWidth.h"

@implementation MinShapeWidth

+ (NSUInteger)minWidthForDevide:(CGRect)devide
                        pallete:(NSMutableArray *)pallete
                     whiteIndex:(NSUInteger)whiteIndex
                     blackIndex:(NSUInteger)blackIndex;
{
    NSUInteger minWidth = NSUIntegerMax;
    //width
    BOOL shape = NO;
    for (int i = devide.origin.y; i < devide.size.height + devide.origin.y; i++) {
        NSUInteger tmpWidth = 0;
        for (int j = devide.origin.x; j < devide.size.width + devide.origin.x; j++) {
            minWidth = [MinShapeWidth minWidthWithRowIndex:i
                                        cellIndex:j
                                     currentWidth:minWidth
                                         tmpWidth:&tmpWidth
                                          isShape:&shape
                                       isVertical:NO
                                          pallete:pallete
                                       whiteIndex:whiteIndex
                                       blackIndex:blackIndex];
        }
    }
    
    //height
    shape = NO;
    for (int j = devide.origin.x; j < devide.size.width + devide.origin.x; j++) {
        NSUInteger tmpWidth = 0;
        for (int i = devide.origin.y; i < devide.size.height + devide.origin.y; i++) {
            minWidth = [MinShapeWidth minWidthWithRowIndex:i
                                        cellIndex:j
                                     currentWidth:minWidth
                                         tmpWidth:&tmpWidth
                                          isShape:&shape
                                       isVertical:YES
                                          pallete:pallete
                                       whiteIndex:whiteIndex
                                       blackIndex:blackIndex];
            
        }
    }
    
    return minWidth;
}

+ (NSUInteger)minWidthWithRowIndex:(NSInteger)rowIndex
                         cellIndex:(NSInteger)cellIndex
                      currentWidth:(NSUInteger)currentWidth
                          tmpWidth:(NSUInteger *)tmpWidth
                           isShape:(BOOL *)isShape
                        isVertical:(BOOL)isVertical
                           pallete:(NSMutableArray *)pallete
                        whiteIndex:(NSUInteger)whiteIndex
                        blackIndex:(NSUInteger)blackIndex
{
    NSUInteger minWidth = currentWidth;
    NSUInteger value = [pallete[rowIndex][0][cellIndex] unsignedIntegerValue];
    NSInteger topCenter = whiteIndex;
    
    if (rowIndex - 1 > 0) {
        topCenter = [pallete[rowIndex - 1][0][cellIndex] unsignedIntegerValue];
    }
    
    NSInteger midleLeft = whiteIndex;
    NSInteger midleRight = [pallete[rowIndex][0][cellIndex + 1] unsignedIntegerValue];
    NSInteger bottomLeft = whiteIndex;
    
    if (cellIndex - 1 > 0) {
        midleLeft = [pallete[rowIndex][0][cellIndex - 1] unsignedIntegerValue];
        
        bottomLeft = [pallete[rowIndex + 1][0][cellIndex - 1] unsignedIntegerValue];
    }
    
    NSInteger bottomCenter = [pallete[rowIndex + 1][0][cellIndex] unsignedIntegerValue];
    
    if (value == blackIndex) {
        if (!(*isShape) && !isVertical && midleLeft == whiteIndex && topCenter == blackIndex && bottomCenter == blackIndex) {
            (*isShape) = YES;
        } else if (!(*isShape) && isVertical && midleRight == blackIndex && midleLeft == blackIndex && topCenter == whiteIndex && bottomCenter == blackIndex) {
            (*isShape) = YES;
        }
        
        if ((*isShape)) {
            (*tmpWidth)++;
        }
    } else if (value == whiteIndex) {
        if ((*tmpWidth) < minWidth && (*tmpWidth)) {
            minWidth = (*tmpWidth);
        }
        (*isShape) = NO;
        (*tmpWidth) = 0;
    }
    return minWidth;
}

@end
