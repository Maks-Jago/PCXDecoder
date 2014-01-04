//
//  DevideThinning.m
//  Lr1_MM
//
//  Created by Max Kuznetsov on 02.01.14.
//  Copyright (c) 2014 111Minutes. All rights reserved.
//

/*
 p3 p2 p1
 p4 ss p0
 p5 p6 p7
 */

#import "DevideThinning.h"
#import "FirstPass.h"

@interface DevideThinning ()

@property (nonatomic, strong) PCXContent *pcxContent;
@property (nonatomic, strong) NSMutableArray *palleteCopy;
@property (nonatomic, strong) NSMutableArray *tmp;

@end

@implementation DevideThinning

- (id)initWithPCXContent:(PCXContent *)pcxContent
{
    if (self) {
        self.pcxContent = pcxContent;
        [self createPalleteCopy];
    }
    return self;
}

- (void)createPalleteCopy
{
    self.palleteCopy = [[NSMutableArray alloc] init];
    for (NSArray *row in self.pcxContent.pallete) {
        NSArray *cell = row[0];
        NSMutableArray *newCell = [NSMutableArray new];
        for (NSNumber *value in cell) {
            [newCell addObject:[NSNumber numberWithUnsignedInteger:[value unsignedIntegerValue]]];
        }
        [self.palleteCopy addObject:@[newCell]];
    }
}

- (void)setWhiteIndex:(NSUInteger)whiteIndex
{
    _whiteIndex = whiteIndex / 3;
}

- (void)setBlackIndex:(NSUInteger)blackIndex
{
    _blackIndex = blackIndex / 3;
}

- (void)thinningDevide:(CGRect)devide
{
    self.tmp = [NSMutableArray new];
    
    int index = 256;
    NSUInteger compareValue = self.whiteIndex;
    while ([self setIndex:index forDevide:devide compareValue:compareValue]) {
        compareValue = index++;
    }
    
    [self replaceAllIndexWithDevide:devide];
    for (NSValue *vv in self.tmp) {
        CGPoint point = [vv CGPointValue];
        [self.palleteCopy[(NSUInteger)point.x][0] replaceObjectAtIndex:(NSUInteger)point.y withObject:[NSNumber numberWithInteger:776]];
    }
    
    self.pcxContent.pallete = self.palleteCopy;
}

- (void)replaceAllIndexWithDevide:(CGRect)devide
{
    for (int i = devide.origin.y; i < devide.size.height + devide.origin.y; i++) {
        NSUInteger maxValue = 256;
        NSUInteger maxValueCount = 0;
        for (int j = devide.origin.x; j < devide.size.width + devide.origin.x; j++) {
            NSUInteger value = [self.palleteCopy[i][0][j] unsignedIntegerValue];
            if (maxValue < value) {
                maxValue = value;
            }
            if (value == maxValue) {
                maxValueCount ++;
            }
        }
        
        for (int j = devide.origin.x; j < devide.size.width + devide.origin.x; j++) {
            NSUInteger value = [self.palleteCopy[i][0][j] unsignedIntegerValue];
            if ((value <= maxValue && value > 255)) {
                NSInteger newColorValue = value == maxValue ? self.blackIndex : self.whiteIndex;
#if DEVIDE_THINNING_DEBUG
                newColorValue = 774;
#endif
                [self.palleteCopy[i][0] replaceObjectAtIndex:j withObject:[NSNumber numberWithInteger:newColorValue]];
            }
        }
    }
}

- (BOOL)setIndex:(NSUInteger)index forDevide:(CGRect)devide compareValue:(NSUInteger)compareValue
{
    BOOL isNeedContinue = NO;
    for (int i = devide.origin.y; i < devide.size.height + devide.origin.y; i++) {
        for (int j = devide.origin.x; j < devide.size.width + devide.origin.x; j++) {
            NSNumber *value = self.palleteCopy[i][0][j];

            if ([value unsignedIntegerValue] != self.blackIndex) {
                continue;
            }
            
            NSUInteger topLeft = [self.palleteCopy[i - 1][0][j - 1] unsignedIntegerValue];
            NSUInteger topCenter = [self.palleteCopy[i - 1][0][j] unsignedIntegerValue];
            NSUInteger topRight = [self.palleteCopy[i - 1][0][j + 1] unsignedIntegerValue];
            
            NSUInteger midleLeft = [self.palleteCopy[i][0][j - 1] unsignedIntegerValue];
            NSUInteger midleCenter = [self.palleteCopy[i][0][j] unsignedIntegerValue];
            NSUInteger midleRight = [self.palleteCopy[i][0][j + 1] unsignedIntegerValue];
            
            NSUInteger bottomLeft = [self.palleteCopy[i + 1][0][j - 1] unsignedIntegerValue];
            NSUInteger bottomCenter = [self.palleteCopy[i + 1][0][j] unsignedIntegerValue];
            NSUInteger bottomRight = [self.palleteCopy[i + 1][0][j + 1] unsignedIntegerValue];

            if (j == devide.size.width) {
//                NSLog(@"\ntopLeft = %d\ntopCenter = %d\ntopRight = %d\nmidleLeft = %d\nmidleCenter = %d\nmidleRight = %d\nbottomLeft = %d\nbottomCenter = %d\nbottomRight = %d", topLeft, topCenter, topRight, midleLeft, midleCenter, midleRight, bottomLeft, bottomCenter, bottomRight);
            }
            
            if (topLeft == compareValue || topCenter == compareValue || topRight == compareValue ||
                midleLeft == compareValue || midleCenter == compareValue || midleRight == compareValue ||
                bottomLeft == compareValue || bottomCenter == compareValue || bottomRight == compareValue) {
                
//                if (topLeft != self.blackIndex && bottomRight != self.blackIndex && topRight != self.blackIndex &&
//                    midleLeft != self.blackIndex && midleCenter == self.blackIndex && midleRight != self.blackIndex &&
//                    bottomLeft != self.blackIndex && bottomCenter != self.blackIndex && bottomRight != self.blackIndex) {
//                    continue;
//                }
                
//                BOOL needSave = NO;
//                if ((topLeft == self.blackIndex && bottomRight == self.blackIndex) || (topRight == self.blackIndex && bottomLeft == self.blackIndex)) {
//                    if ((midleRight != self.blackIndex && midleLeft != self.blackIndex) || (topCenter != self.blackIndex && bottomCenter != self.blackIndex)) {
//                        needSave = YES;
//                    }
//                }
//                
//                if ((topCenter == self.blackIndex && bottomCenter == self.blackIndex) || (midleLeft == self.blackIndex && midleRight == self.blackIndex)) {
//                    if ((topLeft != self.blackIndex && bottomRight != self.blackIndex) || (topRight != self.blackIndex && bottomLeft != self.blackIndex)) {
//                        needSave = YES;
//                    }
//                }
                
                /*
                 0 0 1
                 0 1 0
                 1 0 0
                 */
//                if (topLeft != self.blackIndex && topCenter != self.blackIndex && topRight == self.blackIndex &&
//                    midleLeft != self.blackIndex && midleRight != self.blackIndex &&
//                    bottomLeft == self.blackIndex && bottomCenter != self.blackIndex && bottomRight != self.blackIndex) {
//                    needSave = YES;
//                }
                
                /*
                 0 0 1
                 1 1 0
                 0 0 0
                 */
//                if (topLeft != self.blackIndex && topCenter != self.blackIndex && topRight == self.blackIndex &&
//                    midleLeft == self.blackIndex && midleRight != self.blackIndex &&
//                    bottomLeft != self.blackIndex && bottomCenter != self.blackIndex && bottomRight != self.blackIndex) {
//                    needSave = YES;
//                }
//
//                if (needSave) {
//                    [self.tmp addObject:[NSValue valueWithCGPoint:CGPointMake(i, j)]];
//                    continue;
//                }
                
//                if ( ||
//                    (topCenter == self.blackIndex && bottomCenter == self.blackIndex)) {
//                    [self.tmp addObject:[NSValue valueWithCGPoint:CGPointMake(i, j)]];
//                    continue;
//                }

//                BOOL isTop = NO;
//                BOOL isBottom = NO;
//                
//                if (topLeft == self.blackIndex || topCenter == self.blackIndex || topRight == self.blackIndex) {
//                    isTop = YES;
//                }
//                
//                if (bottomLeft == self.blackIndex || bottomCenter == self.blackIndex || bottomRight == self.blackIndex) {
//                    isBottom = YES;
//                }
//                
//                if (isTop && isBottom && (midleLeft == self.blackIndex || midleRight == self.blackIndex)) {
//                    [self.tmp addObject:[NSValue valueWithCGPoint:CGPointMake(i, j)]];
//                    continue;
//                }
                
//                if (((topLeft == self.blackIndex && bottomRight == self.blackIndex) ||
//                     (topRight == self.blackIndex && bottomLeft == self.blackIndex)) &&
//                    topCenter != self.blackIndex && bottomCenter != self.blackIndex) {
//                    continue;
//                }
                
                [self.palleteCopy[i][0] replaceObjectAtIndex:j withObject:[NSNumber numberWithUnsignedInteger:index]];
                isNeedContinue = YES;
            }
        }
    }
    return isNeedContinue;
}

@end
