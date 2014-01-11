//
//  OnePixelEraser.m
//  Lr1_MM
//
//  Created by Max Kuznetsov on 11.01.14.
//  Copyright (c) 2014 111Minutes. All rights reserved.
//

#import "OnePixelEraser.h"

@implementation OnePixelEraser

+ (void)eraseOnePixel8x8WithDevide:(CGRect)devide
                           pallete:(NSMutableArray *)pallete
                        blackIndex:(NSUInteger)blackIndex
                        whiteIndex:(NSUInteger)whiteIndex;
{
    for (int i = devide.origin.y + 2; i < (devide.size.height + devide.origin.y) - 2; i++) {
        for (int j = devide.origin.x + 2; j < (devide.size.width + devide.origin.x) - 2; j++) {
            NSUInteger value = [pallete[i][0][j] unsignedIntegerValue];
            
            if (value != blackIndex) {
                continue;
            }
            
            NSUInteger topLeft = [pallete[i - 1][0][j - 1] unsignedIntegerValue];
            NSUInteger topLeftLeft = [pallete[i - 2][0][j - 2] unsignedIntegerValue];
            
            NSUInteger topCenter = [pallete[i - 1][0][j] unsignedIntegerValue];
            NSUInteger topCenterCenter = [pallete[i - 2][0][j] unsignedIntegerValue];
            
            NSUInteger topRight = [pallete[i - 1][0][j + 1] unsignedIntegerValue];
            NSUInteger topRightRigth = [pallete[i - 2][0][j + 2] unsignedIntegerValue];
            
            NSUInteger midleLeft = [pallete[i][0][j - 1] unsignedIntegerValue];
            NSUInteger midleLeftLeft = [pallete[i][0][j - 2] unsignedIntegerValue];
            
            NSUInteger bottomLeft = [pallete[i + 1][0][j - 1] unsignedIntegerValue];
            NSUInteger bottomLeftLeft = [pallete[i + 2][0][j - 2] unsignedIntegerValue];
            
            NSUInteger midleRight = [pallete[i][0][j + 1] unsignedIntegerValue];
            NSUInteger midleRightRight = [pallete[i][0][j + 2] unsignedIntegerValue];
            
            NSUInteger bottomCenter = [pallete[i + 1][0][j] unsignedIntegerValue];
            NSUInteger bottomCenterCenter = [pallete[i + 2][0][j] unsignedIntegerValue];
            
            NSUInteger bottomRight = [pallete[i + 1][0][j + 1] unsignedIntegerValue];
            NSUInteger bottomRightRight = [pallete[i + 2][0][j + 2] unsignedIntegerValue];
            
            NSUInteger topCenterCenterLeft = [pallete[i - 2][0][j - 1] unsignedIntegerValue];
            NSUInteger topCenterCenterRight = [pallete[i - 2][0][j + 1] unsignedIntegerValue];
            
            NSUInteger midleLeftLeftTop = [pallete[i - 1][0][j - 2] unsignedIntegerValue];
            NSUInteger midleLeftLeftBottom = [pallete[i + 1][0][j - 2] unsignedIntegerValue];
            
            NSUInteger bottomCenterCenterLeft = [pallete[i + 2][0][j - 1] unsignedIntegerValue];
            NSUInteger bottomCenterCenterRight = [pallete[i + 2][0][j + 1] unsignedIntegerValue];
            
            NSUInteger midleRightRightTop = [pallete[i - 1][0][j + 2] unsignedIntegerValue];
            NSUInteger midleRightRightBottom = [pallete[i + 1][0][j + 2] unsignedIntegerValue];
            
            if (topLeft == whiteIndex && topLeftLeft == whiteIndex &&
                topCenter == whiteIndex && topCenterCenter == whiteIndex &&
                topRight == whiteIndex && topRightRigth == whiteIndex &&
                midleLeft == whiteIndex && midleLeftLeft == whiteIndex &&
                midleRight == whiteIndex && midleRightRight == whiteIndex &&
                bottomLeft == whiteIndex && bottomLeftLeft == whiteIndex &&
                bottomCenter == whiteIndex && bottomCenterCenter == whiteIndex &&
                bottomRight == whiteIndex && bottomRightRight == whiteIndex &&
                topCenterCenterLeft == whiteIndex && topCenterCenterRight == whiteIndex &&
                midleRightRightTop == whiteIndex && midleRightRightBottom == whiteIndex &&
                midleLeftLeftTop == whiteIndex && midleLeftLeftBottom == whiteIndex &&
                bottomCenterCenterLeft == whiteIndex && bottomCenterCenterRight == whiteIndex
                ) {
                [pallete[i][0] replaceObjectAtIndex:j withObject:[NSNumber numberWithInteger:whiteIndex]];
            }
        }
    }
}


@end
