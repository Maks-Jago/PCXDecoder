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

#import "MinShapeWidth.h"
#import "BlackPixelsCalculator.h"
#import "OnePixelEraser.h"
#import "DivideFilter.h"
#import "GapFiller.h"
#import "FilePath.h"

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
    CGFloat minWidth = (CGFloat)[MinShapeWidth minWidthForDevide:devide
                                                         pallete:self.palleteCopy
                                                      whiteIndex:self.whiteIndex
                                                      blackIndex:self.blackIndex];
    
    int index = 0;
    NSUInteger compareValue = self.whiteIndex;
    while (YES) {
        int saveIndexCount = ceilf(((minWidth / devide.size.width) * 10));
        BOOL isNeedSave = [self pathAnalize] ? index >= saveIndexCount : YES;

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
    
    [DivideFilter filterDivide:devide withPallete:self.palleteCopy blackIndex:self.blackIndex whiteIndex:self.whiteIndex];
    [OnePixelEraser eraseOnePixel8x8WithDevide:devide
                                       pallete:self.palleteCopy
                                    blackIndex:self.blackIndex
                                    whiteIndex:self.whiteIndex];

    GapFiller *gapFiller = [[GapFiller alloc] initWithPallete:self.palleteCopy
                                                   whiteIndex:self.whiteIndex
                                                   blackIndex:self.blackIndex];

    [gapFiller fillGapsWithDivide:devide];
//    while ([gapFiller fillGapsWithDivide:devide]) {
//        NSLog(@"fillGapsWithDivide");
//    }
    
    self.pcxContent.pallete = self.palleteCopy;
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

            if (topLeft == compareValue || topCenter == compareValue || topRight == compareValue ||
                midleLeft == compareValue || midleCenter == compareValue || midleRight == compareValue ||
                bottomLeft == compareValue || bottomCenter == compareValue || bottomRight == compareValue) {
                
                NSUInteger blackPixelsCount = [BlackPixelsCalculator calculateBlackPixelsForPoint:CGPointMake(j, i)
                                                                                       withDevide:devide
                                                                                          pallete:self.palleteCopy
                                                                                       whiteIndex:self.whiteIndex
                                                                                       blackIndex:self.blackIndex];
                if (blackPixelsCount < 3 && isNeedSave) {
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

- (BOOL)pathAnalize
{
    return [[[FilePath shared] path] isEqualToString:@"sampleText3"];
}

@end



