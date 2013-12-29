//
//  BaseAperture.m
//  Lr1_MM
//
//  Created by Max Kuznetsov on 29.12.13.
//  Copyright (c) 2013 111Minutes. All rights reserved.
//

#import "BaseAperture.h"

@implementation BaseAperture

- (BOOL)isPixelEqualToAperture:(NSMutableArray *)matr rowsIndex:(NSUInteger)rowsIndex rowIndex:(NSUInteger)rowIndex
{
    NSUInteger topLeft = [matr[rowsIndex - 1][0][rowIndex - 1] unsignedIntegerValue];
    NSUInteger topCenter = [matr[rowsIndex - 1][0][rowIndex] unsignedIntegerValue];
    NSUInteger topRight = [matr[rowsIndex - 1][0][rowIndex + 1] unsignedIntegerValue];
    
    NSUInteger midleLeft = [matr[rowsIndex][0][rowIndex - 1] unsignedIntegerValue];
    NSUInteger midleCenter = [matr[rowsIndex][0][rowIndex] unsignedIntegerValue];
    NSUInteger midleRight = [matr[rowsIndex][0][rowIndex + 1] unsignedIntegerValue];
    
    NSUInteger bottomLeft = [matr[rowsIndex + 1][0][rowIndex - 1] unsignedIntegerValue];
    NSUInteger bottomCenter = [matr[rowsIndex + 1][0][rowIndex] unsignedIntegerValue];
    NSUInteger bottomRight = [matr[rowsIndex + 1][0][rowIndex + 1] unsignedIntegerValue];

    /*
     0 0 0
     0 1 0
     0 0 0
     */
    if (topLeft == self.whiteIndex && topCenter == self.whiteIndex && topRight == self.whiteIndex &&
        midleLeft == self.whiteIndex && midleCenter == self.blackIndex && midleRight == self.whiteIndex &&
        bottomLeft == self.whiteIndex && bottomCenter == self.whiteIndex && bottomRight == self.whiteIndex) {
        return YES;
    }
    
    return NO;
}

- (void)setWhiteIndex:(NSUInteger)whiteIndex
{
    _whiteIndex = whiteIndex / 3;
}

- (void)setBlackIndex:(NSUInteger)blackIndex
{
    _blackIndex = blackIndex / 3;
}

@end
