//
//  TopAperture.m
//  Lr1_MM
//
//  Created by Max Kuznetsov on 29.12.13.
//  Copyright (c) 2013 111Minutes. All rights reserved.
//

#import "TopAperture.h"

@implementation TopAperture

- (BOOL)isPixelEqualToAperture:(NSMutableArray *)matr rowsIndex:(NSUInteger)rowsIndex rowIndex:(NSUInteger)rowIndex
{
    if ([super isPixelEqualToAperture:matr rowsIndex:rowsIndex rowIndex:rowIndex]) {
        return YES;
    }
    
    NSUInteger topLeft = [matr[rowsIndex - 1][0][rowIndex - 1] unsignedIntegerValue];
    NSUInteger topCenter = [matr[rowsIndex - 1][0][rowIndex] unsignedIntegerValue];
    NSUInteger topRight = [matr[rowsIndex - 1][0][rowIndex + 1] unsignedIntegerValue];
    
    NSUInteger midleLeft = [matr[rowsIndex][0][rowIndex - 1] unsignedIntegerValue];
    NSUInteger midleCenter = [matr[rowsIndex][0][rowIndex] unsignedIntegerValue];
    NSUInteger midleRight = [matr[rowsIndex][0][rowIndex + 1] unsignedIntegerValue];
    
    NSUInteger bottomLeft = [matr[rowsIndex + 1][0][rowIndex - 1] unsignedIntegerValue];
    NSUInteger bottomCenter = [matr[rowsIndex + 1][0][rowIndex] unsignedIntegerValue];
    NSUInteger bottomRight = [matr[rowsIndex + 1][0][rowIndex + 1] unsignedIntegerValue];
    
    if (topLeft == self.whiteIndex && topCenter == self.whiteIndex && topRight == self.whiteIndex &&
        midleLeft == self.whiteIndex && midleRight == self.whiteIndex && midleCenter == self.blackIndex) {
       
        /*
           а)       г)
         0 0 0    0 0 0
         0 1 0 || 0 1 0
         1 0 0    1 1 0
        */
        if (bottomLeft == self.blackIndex && (bottomCenter == self.whiteIndex || bottomCenter == self.blackIndex) &&
            bottomRight == self.whiteIndex) {
            return YES;
        }

        /*
           б)
         0 0 0
         0 1 0
         0 1 0
        */
        if (bottomLeft == self.whiteIndex && bottomCenter == self.blackIndex && bottomRight == self.whiteIndex) {
            return YES;
        }
        
        /*
           в)       д)
         0 0 0    0 0 0
         0 1 0 || 0 1 0
         0 0 1    0 1 1
         */
        if (bottomLeft == self.whiteIndex && (bottomCenter == self.whiteIndex || bottomCenter == self.blackIndex) &&
            bottomRight == self.blackIndex) {
            return YES;
        }

        /*
           e)
         0 0 0
         0 1 0
         1 1 1
         */
        if (bottomLeft == self.blackIndex && bottomCenter == self.blackIndex && bottomRight == self.blackIndex) {
            return YES;
        }        
    }
    return NO;
}


@end
