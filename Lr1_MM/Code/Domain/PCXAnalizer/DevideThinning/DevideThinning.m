//
//  DevideThinning.m
//  Lr1_MM
//
//  Created by Max Kuznetsov on 02.01.14.
//  Copyright (c) 2014 111Minutes. All rights reserved.
//

#import "DevideThinning.h"
#import "NSArray+LogMatr.h"
#import "FringeEraser.h"

#import "LeftAperture.h"
#import "TopAperture.h"
#import "RightAperture.h"
#import "BottomAperture.h"

static NSUInteger const kSaveValue = 983;
static NSUInteger const kEraseIndex = 778;

@interface DevideThinning ()

@property (nonatomic, strong) PCXContent *pcxContent;
@property (nonatomic, strong) NSMutableArray *palleteCopy;

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
    CGFloat minWidth = (CGFloat)[self minWidthForDevide:devide];
    
    int index = 0;
    NSUInteger compareValue = self.whiteIndex;
    while (YES) {
        int saveIndexCount = ceilf(((minWidth / devide.size.width) * 10));
        BOOL isNeedSave = index >= saveIndexCount;

        BOOL flag = [self setIndex:256 forDevide:devide compareValue:compareValue isNeedSave:isNeedSave];
        [self replaceAllIndexWithDevide:devide replaceSave:!flag];
        
        if (!flag) {
            break;
        }
        
        index ++;
#if DEVIDE_THINNING_DEBUG
        compareValue = 774;
#endif

    }
    
    [self eraseSimplePixelWithDevide:devide];
    [self eraseOnePixel8x8WithDevide:devide];
    
    self.pcxContent.pallete = self.palleteCopy;
}

- (void)eraseOnePixel8x8WithDevide:(CGRect)devide
{
    for (int i = devide.origin.y + 2; i < (devide.size.height + devide.origin.y) - 2; i++) {
        for (int j = devide.origin.x + 2; j < (devide.size.width + devide.origin.x) - 2; j++) {
            NSUInteger value = [self.palleteCopy[i][0][j] unsignedIntegerValue];
            
            if (value != self.blackIndex) {
                continue;
            }
            
            NSUInteger topLeft = [self.palleteCopy[i - 1][0][j - 1] unsignedIntegerValue];
            NSUInteger topLeftLeft = [self.palleteCopy[i - 2][0][j - 2] unsignedIntegerValue];
            
            NSUInteger topCenter = [self.palleteCopy[i - 1][0][j] unsignedIntegerValue];
            NSUInteger topCenterCenter = [self.palleteCopy[i - 2][0][j] unsignedIntegerValue];

            NSUInteger topRight = [self.palleteCopy[i - 1][0][j + 1] unsignedIntegerValue];
            NSUInteger topRightRigth = [self.palleteCopy[i - 2][0][j + 2] unsignedIntegerValue];
            
            NSUInteger midleLeft = [self.palleteCopy[i][0][j - 1] unsignedIntegerValue];
            NSUInteger midleLeftLeft = [self.palleteCopy[i][0][j - 2] unsignedIntegerValue];
            
            NSUInteger bottomLeft = [self.palleteCopy[i + 1][0][j - 1] unsignedIntegerValue];
            NSUInteger bottomLeftLeft = [self.palleteCopy[i + 2][0][j - 2] unsignedIntegerValue];
            
            NSUInteger midleRight = [self.palleteCopy[i][0][j + 1] unsignedIntegerValue];
            NSUInteger midleRightRight = [self.palleteCopy[i][0][j + 2] unsignedIntegerValue];
            
            NSUInteger bottomCenter = [self.palleteCopy[i + 1][0][j] unsignedIntegerValue];
            NSUInteger bottomCenterCenter = [self.palleteCopy[i + 2][0][j] unsignedIntegerValue];
            
            NSUInteger bottomRight = [self.palleteCopy[i + 1][0][j + 1] unsignedIntegerValue];
            NSUInteger bottomRightRight = [self.palleteCopy[i + 2][0][j + 2] unsignedIntegerValue];
            
            NSUInteger topCenterCenterLeft = [self.palleteCopy[i - 2][0][j - 1] unsignedIntegerValue];
            NSUInteger topCenterCenterRight = [self.palleteCopy[i - 2][0][j + 1] unsignedIntegerValue];
            
            NSUInteger midleLeftLeftTop = [self.palleteCopy[i - 1][0][j - 2] unsignedIntegerValue];
            NSUInteger midleLeftLeftBottom = [self.palleteCopy[i + 1][0][j - 2] unsignedIntegerValue];
            
            NSUInteger bottomCenterCenterLeft = [self.palleteCopy[i + 2][0][j - 1] unsignedIntegerValue];
            NSUInteger bottomCenterCenterRight = [self.palleteCopy[i + 2][0][j + 1] unsignedIntegerValue];
            
            NSUInteger midleRightRightTop = [self.palleteCopy[i - 1][0][j + 2] unsignedIntegerValue];
            NSUInteger midleRightRightBottom = [self.palleteCopy[i + 1][0][j + 2] unsignedIntegerValue];
            
            if (topLeft == self.whiteIndex && topLeftLeft == self.whiteIndex &&
                topCenter == self.whiteIndex && topCenterCenter == self.whiteIndex &&
                topRight == self.whiteIndex && topRightRigth == self.whiteIndex &&
                midleLeft == self.whiteIndex && midleLeftLeft == self.whiteIndex &&
                midleRight == self.whiteIndex && midleRightRight == self.whiteIndex &&
                bottomLeft == self.whiteIndex && bottomLeftLeft == self.whiteIndex &&
                bottomCenter == self.whiteIndex && bottomCenterCenter == self.whiteIndex &&
                bottomRight == self.whiteIndex && bottomRightRight == self.whiteIndex &&
                topCenterCenterLeft == self.whiteIndex && topCenterCenterRight == self.whiteIndex &&
                midleRightRightTop == self.whiteIndex && midleRightRightBottom == self.whiteIndex &&
                midleLeftLeftTop == self.whiteIndex && midleLeftLeftBottom == self.whiteIndex &&
                bottomCenterCenterLeft == self.whiteIndex && bottomCenterCenterRight == self.whiteIndex
                ) {
                [self.palleteCopy[i][0] replaceObjectAtIndex:j withObject:[NSNumber numberWithInteger:self.whiteIndex]];
            }
        }
    }
}

- (void)eraseSimplePixelWithDevide:(CGRect)devide
{
    for (int i = devide.origin.y; i < devide.size.height + devide.origin.y; i++) {
        for (int j = devide.origin.x; j < devide.size.width + devide.origin.x; j++) {
            NSUInteger value = [self.palleteCopy[i][0][j] unsignedIntegerValue];
            
            if (value != self.blackIndex && value != kSaveValue) {
                continue;
            }
            
            NSUInteger topLeft = self.whiteIndex;
            NSUInteger topCenter = self.whiteIndex;
            NSUInteger topRight = self.whiteIndex;
            
            if (j - 1 > 0 && i - 1 > 0) {
                topLeft = [self.palleteCopy[i - 1][0][j - 1] unsignedIntegerValue];
                topCenter = [self.palleteCopy[i - 1][0][j] unsignedIntegerValue];
                topRight = [self.palleteCopy[i - 1][0][j + 1] unsignedIntegerValue];
            }
            
            NSUInteger midleLeft = self.whiteIndex;
            NSUInteger bottomLeft = self.whiteIndex;
            
            if (j - 1 > 0) {
                midleLeft = [self.palleteCopy[i][0][j - 1] unsignedIntegerValue];
                bottomLeft = [self.palleteCopy[i + 1][0][j - 1] unsignedIntegerValue];
            }
            
            
            NSUInteger midleRight = [self.palleteCopy[i][0][j + 1] unsignedIntegerValue];
            
            NSUInteger bottomCenter = [self.palleteCopy[i + 1][0][j] unsignedIntegerValue];
            NSUInteger bottomRight = [self.palleteCopy[i + 1][0][j + 1] unsignedIntegerValue];
            
            midleLeft = [self convertValue:midleLeft];
            midleRight = [self convertValue:midleRight];
            
            topLeft = [self convertValue:topLeft];
            topRight = [self convertValue:topRight];
            topCenter = [self convertValue:topCenter];
            
            bottomCenter = [self convertValue:bottomCenter];
            bottomLeft = [self convertValue:bottomLeft];
            bottomRight = [self convertValue:bottomRight];
            
            
            /*
             0 0 1
             0 1 0
             1 0 0
             */
            if (midleLeft == self.whiteIndex && midleRight == self.whiteIndex  &&
                topLeft == self.whiteIndex && (topCenter == self.whiteIndex || topCenter == kEraseIndex) && (topRight == self.whiteIndex || topRight == kEraseIndex) &&
                (bottomLeft == self.blackIndex || topRight == kEraseIndex) && bottomCenter == self.whiteIndex  && bottomRight == self.whiteIndex) {
                [self.palleteCopy[i][0] replaceObjectAtIndex:j withObject:[NSNumber numberWithInteger:kEraseIndex]];
            }
        }
    }
    
//    for (int i = devide.origin.y; i < devide.size.height + devide.origin.y; i++) {
//        for (int j = devide.origin.x; j < devide.size.width + devide.origin.x; j++) {
//            NSUInteger value = [self.palleteCopy[i][0][j] unsignedIntegerValue];
//            if (value == eraseIndex) {
//                [self.palleteCopy[i][0] replaceObjectAtIndex:j withObject:[NSNumber numberWithInteger:self.whiteIndex]];
//            }
//        }
//    }
}

- (NSUInteger)convertValue:(NSUInteger)value
{
    if (value == kSaveValue || value == 774) {
        return self.blackIndex;
    }
    return value;
}

- (NSUInteger)minWidthForDevide:(CGRect)devide
{
    NSUInteger minWidth = NSUIntegerMax;
    //width
    BOOL shape = NO;
    for (int i = devide.origin.y; i < devide.size.height + devide.origin.y; i++) {
        NSUInteger tmpWidth = 0;
        for (int j = devide.origin.x; j < devide.size.width + devide.origin.x; j++) {
            minWidth = [self minWidthWithRowIndex:i
                                        cellIndex:j
                                     currentWidth:minWidth
                                         tmpWidth:&tmpWidth
                                          isShape:&shape
                                       isVertical:NO];
        }
    }

    //height
    shape = NO;
    for (int j = devide.origin.x; j < devide.size.width + devide.origin.x; j++) {
        NSUInteger tmpWidth = 0;
        for (int i = devide.origin.y; i < devide.size.height + devide.origin.y; i++) {
            minWidth = [self minWidthWithRowIndex:i
                                        cellIndex:j
                                     currentWidth:minWidth
                                         tmpWidth:&tmpWidth
                                          isShape:&shape
                                       isVertical:YES];

        }
    }
    
    return minWidth;
}

- (NSUInteger)minWidthWithRowIndex:(NSInteger)rowIndex
                         cellIndex:(NSInteger)cellIndex
                      currentWidth:(NSUInteger)currentWidth
                          tmpWidth:(NSUInteger *)tmpWidth
                           isShape:(BOOL *)isShape
                        isVertical:(BOOL)isVertical
{
    NSUInteger minWidth = currentWidth;
    NSUInteger value = [self.palleteCopy[rowIndex][0][cellIndex] unsignedIntegerValue];
    NSInteger topCenter = self.whiteIndex;
    
    if (rowIndex - 1 > 0) {
        topCenter = [self.palleteCopy[rowIndex - 1][0][cellIndex] unsignedIntegerValue];
    }
    
    NSInteger midleLeft = self.whiteIndex;
    NSInteger midleRight = [self.palleteCopy[rowIndex][0][cellIndex + 1] unsignedIntegerValue];
    NSInteger bottomLeft = self.whiteIndex;
    
    if (cellIndex - 1 > 0) {
        midleLeft = [self.palleteCopy[rowIndex][0][cellIndex - 1] unsignedIntegerValue];
        
        bottomLeft = [self.palleteCopy[rowIndex + 1][0][cellIndex - 1] unsignedIntegerValue];
    }
    
    NSInteger bottomCenter = [self.palleteCopy[rowIndex + 1][0][cellIndex] unsignedIntegerValue];
    
    if (value == self.blackIndex) {
        if (!(*isShape) && !isVertical && midleLeft == self.whiteIndex && topCenter == self.blackIndex && bottomCenter == self.blackIndex) {
            (*isShape) = YES;
        } else if (!(*isShape) && isVertical && midleRight == self.blackIndex && midleLeft == self.blackIndex && topCenter == self.whiteIndex && bottomCenter == self.blackIndex) {
            (*isShape) = YES;
        }

        if ((*isShape)) {
            (*tmpWidth)++;
        }
    } else if (value == self.whiteIndex) {
        if ((*tmpWidth) < minWidth && (*tmpWidth)) {
            minWidth = (*tmpWidth);
        }
        (*isShape) = NO;
        (*tmpWidth) = 0;
    }
    return minWidth;
}

- (NSUInteger)calculateBlackPixelsForPoint:(CGPoint)point
{
    NSUInteger blackPixelsCount = 0;
    int i = (int)point.y;
    int j = (int)point.x;
    
    NSUInteger topLeft = self.whiteIndex;
    NSUInteger topCenter = self.whiteIndex;
    NSUInteger topRight = self.whiteIndex;
    
    if (j - 1 > 0 && i - 1 > 0) {
        topLeft = [self.palleteCopy[i - 1][0][j - 1] unsignedIntegerValue];
        topCenter = [self.palleteCopy[i - 1][0][j] unsignedIntegerValue];
        topRight = [self.palleteCopy[i - 1][0][j + 1] unsignedIntegerValue];
    }
    
    NSUInteger midleLeft = self.whiteIndex;
    NSUInteger bottomLeft = self.whiteIndex;
    
    if (j - 1 > 0) {
        midleLeft = [self.palleteCopy[i][0][j - 1] unsignedIntegerValue];
        bottomLeft = [self.palleteCopy[i + 1][0][j - 1] unsignedIntegerValue];
    }


    NSUInteger midleRight = [self.palleteCopy[i][0][j + 1] unsignedIntegerValue];

    NSUInteger bottomCenter = [self.palleteCopy[i + 1][0][j] unsignedIntegerValue];
    NSUInteger bottomRight = [self.palleteCopy[i + 1][0][j + 1] unsignedIntegerValue];

    blackPixelsCount = [self incrementIndex:blackPixelsCount withValue:topLeft maxValue:self.blackIndex];
    blackPixelsCount = [self incrementIndex:blackPixelsCount withValue:topCenter maxValue:self.blackIndex];
    blackPixelsCount = [self incrementIndex:blackPixelsCount withValue:topRight maxValue:self.blackIndex];
    blackPixelsCount = [self incrementIndex:blackPixelsCount withValue:midleLeft maxValue:self.blackIndex];
    blackPixelsCount = [self incrementIndex:blackPixelsCount withValue:midleRight maxValue:self.blackIndex];
    blackPixelsCount = [self incrementIndex:blackPixelsCount withValue:bottomLeft maxValue:self.blackIndex];
    blackPixelsCount = [self incrementIndex:blackPixelsCount withValue:bottomCenter maxValue:self.blackIndex];
    blackPixelsCount = [self incrementIndex:blackPixelsCount withValue:bottomRight maxValue:self.blackIndex];
    
    return blackPixelsCount;
}


- (void)replaceAllIndexWithDevide:(CGRect)devide replaceSave:(BOOL)replaceSave
{
    for (int i = devide.origin.y; i < devide.size.height + devide.origin.y; i++) {
        for (int j = devide.origin.x; j < devide.size.width + devide.origin.x; j++) {
            NSUInteger value = [self.palleteCopy[i][0][j] unsignedIntegerValue];
            if (value == kSaveValue && replaceSave) {
                [self.palleteCopy[i][0] replaceObjectAtIndex:j withObject:[NSNumber numberWithInteger:self.blackIndex]];
            } else if (value == 256) {
                NSInteger newColorValue = self.whiteIndex;
#if DEVIDE_THINNING_DEBUG
                newColorValue = 774;
#endif
                [self.palleteCopy[i][0] replaceObjectAtIndex:j withObject:[NSNumber numberWithInteger:newColorValue]];
            }
        }
    }
}

- (BOOL)setIndex:(NSUInteger)index forDevide:(CGRect)devide compareValue:(NSUInteger)compareValue isNeedSave:(BOOL)isNeedSave
{
    BOOL isNeedContinue = NO;
    for (int i = devide.origin.y; i < devide.size.height + devide.origin.y; i++) {
        for (int j = devide.origin.x; j < devide.size.width + devide.origin.x; j++) {
            NSNumber *value = self.palleteCopy[i][0][j];
            
            if ([value unsignedIntegerValue] != self.blackIndex) {
                continue;
            }
            
            NSUInteger topLeft = self.whiteIndex;
            NSUInteger topCenter = self.whiteIndex;
            NSUInteger topRight = self.whiteIndex;
            
            if (j - 1 > 0 && i - 1 > 0) {
                topLeft = [self.palleteCopy[i - 1][0][j - 1] unsignedIntegerValue];
                topCenter = [self.palleteCopy[i - 1][0][j] unsignedIntegerValue];
                topRight = [self.palleteCopy[i - 1][0][j + 1] unsignedIntegerValue];
            }
            
            NSUInteger midleLeft = self.whiteIndex;
            NSUInteger bottomLeft = self.whiteIndex;
            
            if (j - 1 > 0) {
                midleLeft = [self.palleteCopy[i][0][j - 1] unsignedIntegerValue];
                bottomLeft = [self.palleteCopy[i + 1][0][j - 1] unsignedIntegerValue];
            }
            
            
            NSUInteger midleCenter = [self.palleteCopy[i][0][j] unsignedIntegerValue];
            NSUInteger midleRight = [self.palleteCopy[i][0][j + 1] unsignedIntegerValue];
            
            NSUInteger bottomCenter = [self.palleteCopy[i + 1][0][j] unsignedIntegerValue];
            NSUInteger bottomRight = [self.palleteCopy[i + 1][0][j + 1] unsignedIntegerValue];

//            if (j == devide.size.width) {
//                NSLog(@"\ntopLeft = %d\ntopCenter = %d\ntopRight = %d\nmidleLeft = %d\nmidleCenter = %d\nmidleRight = %d\nbottomLeft = %d\nbottomCenter = %d\nbottomRight = %d", topLeft, topCenter, topRight, midleLeft, midleCenter, midleRight, bottomLeft, bottomCenter, bottomRight);
//            }
            
            if (topLeft == compareValue || topCenter == compareValue || topRight == compareValue ||
                midleLeft == compareValue || midleCenter == compareValue || midleRight == compareValue ||
                bottomLeft == compareValue || bottomCenter == compareValue || bottomRight == compareValue) {
                
                if ([self calculateBlackPixelsForPoint:CGPointMake(j, i)] < 3 && isNeedSave) {
                    [self.palleteCopy[i][0] replaceObjectAtIndex:j withObject:[NSNumber numberWithUnsignedInteger:kSaveValue]];
                } else {
                    [self.palleteCopy[i][0] replaceObjectAtIndex:j withObject:[NSNumber numberWithUnsignedInteger:index]];
                }
                isNeedContinue = YES;
            }
        }
    }
    return isNeedContinue;
}

- (NSUInteger)incrementIndex:(NSUInteger)index withValue:(NSUInteger)value maxValue:(NSUInteger)maxValue
{
    if (value == maxValue) {
        return index + 1;
    }
    return index;
}

@end



