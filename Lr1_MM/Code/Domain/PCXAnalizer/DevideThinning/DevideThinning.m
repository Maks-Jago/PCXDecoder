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
//    int count = 0;
    NSUInteger compareValue = self.whiteIndex;
    while (YES) {
        BOOL flag = [self setIndex:index forDevide:devide compareValue:compareValue];
        [self replaceAllIndexWithDevide:devide replaceSave:!flag];
        if (!flag) {
            break;
        }
        
//        count++;
//        if (count == 3) {
//            break;
//        }
        
#if DEVIDE_THINNING_DEBUG
        compareValue = 774;
#endif

    }
    
//    [self replaceIndexForDevide:devide];
//    [self replaceAllIndexWithDevide:devide];
    
    self.pcxContent.pallete = self.palleteCopy;
}

- (void)replaceIndexForDevide:(CGRect)devide
{
    CGPoint maxIndexOrigin = CGPointZero;
    NSUInteger maxValue = 256;
    for (int i = devide.origin.y; i < devide.size.height + devide.origin.y; i++) {
        for (int j = devide.origin.x; j < devide.size.width + devide.origin.x; j++) {
            NSUInteger value = [self.palleteCopy[i][0][j] unsignedIntegerValue];
            if (maxValue < value) {
                maxValue = value;
                maxIndexOrigin = CGPointMake(j, i);
            }
        }
    }
    
    NSLog(@"");
//    [self.palleteCopy[(NSUInteger)maxIndexOrigin.y][0]
//     replaceObjectAtIndex:(NSUInteger)maxIndexOrigin.x
//     withObject:[NSNumber numberWithInteger:775]];
    [self findPathFromPoint:maxIndexOrigin inWay:0];
}

- (void)findPathFromPoint:(CGPoint)point inWay:(NSInteger)way
{
    int i = (int)point.y;
    int j = (int)point.x;
    
    NSUInteger value = [self.palleteCopy[i][0][j] unsignedIntegerValue];
    if (value == self.blackIndex || value == self.whiteIndex) {
        return;
    }
    
    [self.palleteCopy[i][0] replaceObjectAtIndex:j withObject:[NSNumber numberWithInteger:self.blackIndex]];
    
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
    
    NSUInteger max = 0;
    CGPoint newPoint = CGPointZero;
    
    BOOL analizeTopLeft = YES;
    BOOL analizeTopCenter = YES;
    BOOL analizeTopRight = YES;
    
    BOOL analizeMidleLeft = YES;
    BOOL analizeMidleRight = YES;
    
    BOOL analizeBottomLeft = YES;
    BOOL analizeBottomCenter = YES;
    BOOL analizeBottomRight = YES;
    
    do {
        if (!analizeTopLeft && !analizeTopCenter && !analizeTopRight &&
            !analizeMidleLeft && !analizeMidleRight &&
            !analizeBottomLeft && !analizeBottomCenter && !analizeBottomRight) {
            newPoint = CGPointZero;
            break;
        }
        
        if (max > 10) {
            newPoint = CGPointZero;
            break;
        }
        
        if (max < topCenter && analizeTopCenter) {
            max = topCenter;
            newPoint = CGPointMake(j, i - 1);
            
            if ([self calculateBlackPixelsForPoint:newPoint] > 1) {
                analizeTopCenter = NO;
                newPoint = CGPointZero;
                max = - 1;
            }
        }
        
        if (max < topLeft && analizeTopLeft) {
            max = topLeft;
            newPoint = CGPointMake(j - 1, i - 1);
            
            if ([self calculateBlackPixelsForPoint:newPoint] > 1) {
                analizeTopLeft = NO;
                newPoint = CGPointZero;
                max = -1;
            }

        }
        
        if (max < topRight && analizeTopRight) {
            max = topRight;
            newPoint = CGPointMake(j + 1, i - 1);
            
            if ([self calculateBlackPixelsForPoint:newPoint] > 1) {
                analizeTopRight = NO;
                newPoint = CGPointZero;
                max = -1;
            }
        }
        
        if (max < midleLeft && analizeMidleLeft) {
            max = midleLeft;
            newPoint = CGPointMake(j - 1, i);
            
            if ([self calculateBlackPixelsForPoint:newPoint] > 1) {
                analizeMidleLeft = NO;
                newPoint = CGPointZero;
                max = -1;
            }
        }
        
        if (max < midleRight && analizeMidleRight) {
            max = midleRight;
            newPoint = CGPointMake(j + 1, i);
            
            if ([self calculateBlackPixelsForPoint:newPoint] > 1) {
                analizeMidleRight = NO;
                newPoint = CGPointZero;
                max = -1;
            }
        }
        
        if (max < bottomLeft && analizeBottomLeft) {
            max = bottomLeft;
            newPoint = CGPointMake(j - 1, i + 1);
            
            if ([self calculateBlackPixelsForPoint:newPoint] > 1) {
                analizeBottomLeft = NO;
                newPoint = CGPointZero;
                max = -1;
            }
        }
        
        if (max < bottomCenter && analizeBottomCenter) {
            max = bottomCenter;
            newPoint = CGPointMake(j, i + 1);
            
            if ([self calculateBlackPixelsForPoint:newPoint] > 1) {
                analizeBottomCenter = NO;
                newPoint = CGPointZero;
                max = -1;
            }
        }
        
        if (max < bottomRight && analizeBottomRight) {
            max = bottomRight;
            newPoint = CGPointMake(j + 1, i + 1);
            
            if ([self calculateBlackPixelsForPoint:newPoint] > 1) {
                analizeBottomRight = NO;
                newPoint = CGPointZero;
                max = -1;
            }
        }
        max++;
        
    } while (CGPointEqualToPoint(newPoint, CGPointZero));
    
    if (!CGPointEqualToPoint(newPoint, CGPointZero)) {
        [self findPathFromPoint:newPoint inWay:way];
    }
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
//    BOOL shape = NO;
    for (int i = devide.origin.y; i < devide.size.height + devide.origin.y; i++) {
//        NSUInteger maxValue = 256;
//        NSMutableArray *maxValues = [NSMutableArray new];
//        for (int j = devide.origin.x; j < devide.size.width + devide.origin.x; j++) {
//            for (int row = devide.origin.y; row < devide.size.height + devide.origin.y; row++) {
//                NSUInteger value = [self.palleteCopy[i][0][j] unsignedIntegerValue];
//            }
//            
//            NSUInteger value = [self.palleteCopy[i][0][j] unsignedIntegerValue];
//            if (value != self.whiteIndex && !shape) {
//                shape = YES;
//            }
//            
//            if (value == self.whiteIndex && shape) {
//                shape = NO;
//                if (maxValue > 256) {
//                    [maxValues addObject:[NSNumber numberWithInteger:maxValue]];
//                }
//                maxValue = 256;
//            }
//            
//            if (shape) {
//                if (maxValue < value) {
//                    maxValue = value;
//                }
//            }
//        }
//        
//        
//        if ([maxValues count] > 1) {
//            NSLog(@"maxValues = %@", maxValues);
//        }
        
        for (int j = devide.origin.x; j < devide.size.width + devide.origin.x; j++) {
            NSUInteger value = [self.palleteCopy[i][0][j] unsignedIntegerValue];
            if (value == kSaveValue && replaceSave) {
                [self.palleteCopy[i][0] replaceObjectAtIndex:j withObject:[NSNumber numberWithInteger:self.blackIndex]];
            } else if (value == 256) {
                NSInteger newColorValue = self.whiteIndex;
#if DEVIDE_THINNING_DEBUG
                newColorValue = 774;
#endif

//                for (NSNumber *maxValue in maxValues) {
//                    if (value == [maxValue integerValue]) {
//                        newColorValue = self.blackIndex;
//                    }
//                }
//                NSInteger newColorValue = (value == maxValue && maxValue > 256) ? self.blackIndex : self.whiteIndex;
//#if DEVIDE_THINNING_DEBUG
//                newColorValue = 774;
//#endif
//                if (value == maxValue) {
//                    newColorValue = self.blackIndex;
//                }
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
                    [self.palleteCopy[i][0] replaceObjectAtIndex:j withObject:[NSNumber numberWithUnsignedInteger:776]];
                    continue;
                }
//                NSUInteger count = 0;
//                count = [self incrementIndex:count withValue:topLeft maxValue:compareValue];
//                count = [self incrementIndex:count withValue:topCenter maxValue:compareValue];
//                count = [self incrementIndex:count withValue:topRight maxValue:compareValue];
//                count = [self incrementIndex:count withValue:midleLeft maxValue:compareValue];
//                count = [self incrementIndex:count withValue:midleCenter maxValue:compareValue];
//                count = [self incrementIndex:count withValue:midleRight maxValue:compareValue];
//                count = [self incrementIndex:count withValue:bottomLeft maxValue:compareValue];
//                count = [self incrementIndex:count withValue:bottomCenter maxValue:compareValue];
//                count = [self incrementIndex:count withValue:bottomRight maxValue:compareValue];
                
//                if (count < 3) {
//                if (count > 2) {
//                if (compareValue > 256 && (((topCenter != self.blackIndex && bottomCenter != self.blackIndex) &&
//                                            (midleLeft != self.blackIndex && topCenter != self.blackIndex)) ||
//                                           (topLeft != self.blackIndex && bottomRight != self.blackIndex) &&
//                                           (topRight))) {
//                    continue;
//                }
                    [self.palleteCopy[i][0] replaceObjectAtIndex:j withObject:[NSNumber numberWithUnsignedInteger:index]];
                    isNeedContinue = YES;
//                }
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



