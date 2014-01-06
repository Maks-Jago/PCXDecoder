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
#import "NSArray+LogMatr.h"

static NSUInteger const kSaveValue = 983;

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
    int index = 256;
    NSUInteger compareValue = self.whiteIndex;
    while (YES) {
        BOOL flag = [self setIndex:index forDevide:devide compareValue:compareValue];
        [self replaceAllIndexWithDevide:devide replaceSave:!flag];
        if (!flag) {
            break;
        }
        
#if DEVIDE_THINNING_DEBUG
        compareValue = 774;
#endif

    }
    self.pcxContent.pallete = self.palleteCopy;
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

- (BOOL)setIndex:(NSUInteger)index forDevide:(CGRect)devide compareValue:(NSUInteger)compareValue
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
                
                if ([self calculateBlackPixelsForPoint:CGPointMake(j, i)] < 3) {
                    [self.palleteCopy[i][0] replaceObjectAtIndex:j withObject:[NSNumber numberWithUnsignedInteger:kSaveValue]];
                    continue;
                }
                [self.palleteCopy[i][0] replaceObjectAtIndex:j withObject:[NSNumber numberWithUnsignedInteger:index]];
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



