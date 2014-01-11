//
//  DivideFilter.m
//  Lr1_MM
//
//  Created by Max Kuznetsov on 11.01.14.
//  Copyright (c) 2014 111Minutes. All rights reserved.
//

#import "DivideFilter.h"
#import "BlackPixelsCalculator.h"

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
                
                if (j + 1 < [pallete[i - 1][0] count]) {
                    topRight = [pallete[i - 1][0][j + 1] unsignedIntegerValue];
                }
            }
            
            NSUInteger midleLeft = whiteIndex;
            NSUInteger bottomLeft = whiteIndex;
            
            if (j - 1 > 0) {
                midleLeft = [pallete[i][0][j - 1] unsignedIntegerValue];
                
                if (i + 1 < pallete.count) {
                    bottomLeft = [pallete[i + 1][0][j - 1] unsignedIntegerValue];
                }
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
            
            if (topRight == kEraseIndex) {
                NSLog(@"");
            }
            
            if (midleLeft == whiteIndex && midleRight == whiteIndex  &&
                topLeft == whiteIndex && topCenter == whiteIndex && topRight == whiteIndex &&
                bottomLeft == blackIndex && bottomCenter == whiteIndex  && bottomRight == whiteIndex) {
                
                if (i - 2 > 0 && j + 2 < [pallete[i - 2][0] count]) {
                    if ([self isNeedAnalize:CGPointMake(j + 2, i - 2)
                                     divide:divide
                                    pallete:pallete
                                 whiteIndex:whiteIndex
                                 blackIndex:blackIndex]) {
                        [self fromRightToLeft:CGPointMake(j, i) pallete:pallete whiteIndex:whiteIndex blackIndex:blackIndex];
                    }
                }
            } else if (midleLeft == whiteIndex && midleRight == whiteIndex &&
                bottomLeft == whiteIndex && bottomCenter == whiteIndex && bottomRight == whiteIndex &&
                topRight == blackIndex && topCenter == whiteIndex && topLeft == whiteIndex) {
                
                if (i + 2 < pallete.count && j - 2 > 0) {

                    if ([self isNeedAnalize:CGPointMake(j - 2, i + 2)
                                     divide:divide
                                    pallete:pallete
                                 whiteIndex:whiteIndex
                                 blackIndex:blackIndex]) {
                        [self fromBottomLeftToTopRight:CGPointMake(j, i) pallete:pallete whiteIndex:whiteIndex blackIndex:blackIndex];
                    }
                }
            } else if (midleLeft == whiteIndex && midleRight == whiteIndex &&
                       bottomCenter == whiteIndex && bottomRight == whiteIndex &&
                       (topRight == whiteIndex || topRight == kEraseIndex) && topCenter == whiteIndex && topLeft == blackIndex) {
                
                if (i + 2 < pallete.count && j + 2 < [pallete[i + 2][0] count]) {
                    if ([self isNeedAnalize:CGPointMake(j + 2, i + 2)
                                     divide:divide
                                    pallete:pallete
                                 whiteIndex:whiteIndex
                                 blackIndex:blackIndex]) {
                        [self fromBottomRightToTopLeft:CGPointMake(j, i) pallete:pallete whiteIndex:whiteIndex blackIndex:blackIndex];
                    }
                }
            }
        }
    }
}

+ (BOOL)isNeedAnalize:(CGPoint)location
               divide:(CGRect)divide
              pallete:(NSMutableArray *)pallete
           whiteIndex:(NSUInteger)whiteIndex 
           blackIndex:(NSUInteger)blackIndex
{
    NSUInteger count = [BlackPixelsCalculator calculateBlackPixelsForPoint:location
                                                                withDevide:divide
                                                                   pallete:pallete
                                                                whiteIndex:whiteIndex
                                                                blackIndex:blackIndex];
    return !count;
}

/*
 0 0 0 0
 0 0 1 0
 0 1 0 0
 1 0 0 0
 */
+ (void)fromRightToLeft:(CGPoint)location pallete:(NSMutableArray *)pallete whiteIndex:(NSUInteger)whiteIndex blackIndex:(NSUInteger)blackIndex
{
    int i = location.y;
    int j = location.x;
    
    BOOL needContinue = NO;
    do {
        needContinue = NO;
        if (i >= pallete.count || j < 0) {
            break;
        }
        
        NSUInteger topLeft = whiteIndex;
        NSUInteger topCenter = whiteIndex;
        NSUInteger topRight = whiteIndex;
        NSUInteger midleLeft = whiteIndex;
        NSUInteger midleRight = whiteIndex;
        NSUInteger bottomCenter = whiteIndex;
        NSUInteger bottomLeft = whiteIndex;
        NSUInteger bottomRight = whiteIndex;
        
        if (i - 1 > 0) {
            if (j - 1 > 0) {
                topLeft = [pallete[i - 1][0][j - 1] unsignedIntegerValue];
            }
            
            topCenter = [pallete[i - 1][0][j] unsignedIntegerValue];
            
            if (j + 1 < [pallete[i][0] count]) {
                topRight = [pallete[i - 1][0][j + 1] unsignedIntegerValue];
            }
        }
        
        if (j - 1 > 0) {
            midleLeft = [pallete[i][0][j - 1] unsignedIntegerValue];
        }
        
        if (j + 1 < [pallete[i][0] count]) {
            midleRight = [pallete[i][0][j + 1] unsignedIntegerValue];
        }
        
        if (i + 1 < pallete.count) {
            bottomCenter = [pallete[i + 1][0][j] unsignedIntegerValue];

            if (j - 1 > 0) {
                bottomLeft = [pallete[i + 1][0][j - 1] unsignedIntegerValue];
            }
            
            if (j + 1 < [pallete[i + 1][0] count]) {
                bottomRight = [pallete[i + 1][0][j + 1] unsignedIntegerValue];
            }
        }
        
        if (midleLeft == whiteIndex && midleRight == whiteIndex  &&
            topLeft == whiteIndex && (topCenter == whiteIndex || topCenter == kEraseIndex) && (topRight == whiteIndex || topRight == kEraseIndex) &&
            (bottomLeft == blackIndex || topRight == kEraseIndex) && bottomCenter == whiteIndex  && bottomRight == whiteIndex) {
            [pallete[i][0] replaceObjectAtIndex:j withObject:[NSNumber numberWithInteger:whiteIndex]];
            needContinue = YES;
        }
        
        i ++;
        j --;
    } while (needContinue);
}


/*
 0 0 0 1
 0 0 1 0
 0 1 0 0
 0 0 0 0
 */
+ (void)fromBottomLeftToTopRight:(CGPoint)location
                         pallete:(NSMutableArray *)pallete
                      whiteIndex:(NSUInteger)whiteIndex
                      blackIndex:(NSUInteger)blackIndex
{
    int i = location.y;
    int j = location.x;
    BOOL needContinue = NO;
    do {
        needContinue = NO;
        if (j >= [pallete[i][0] count] || i < 0) {
            break;
        }
        
        NSUInteger topLeft = whiteIndex;
        NSUInteger topCenter = whiteIndex;
        NSUInteger topRight = whiteIndex;
        NSUInteger midleLeft = whiteIndex;
        NSUInteger midleRight = whiteIndex;
        NSUInteger bottomCenter = whiteIndex;
        NSUInteger bottomLeft = whiteIndex;
        NSUInteger bottomRight = whiteIndex;
        
        if (i - 1 > 0) {
            if (j - 1 > 0) {
                topLeft = [pallete[i - 1][0][j - 1] unsignedIntegerValue];
            }
            
            topCenter = [pallete[i - 1][0][j] unsignedIntegerValue];
            
            if (j + 1 < [pallete[i][0] count]) {
                topRight = [pallete[i - 1][0][j + 1] unsignedIntegerValue];
            }
        }
        
        if (j - 1 > 0) {
            midleLeft = [pallete[i][0][j - 1] unsignedIntegerValue];
        }
        
        if (j + 1 < [pallete[i][0] count]) {
            midleRight = [pallete[i][0][j + 1] unsignedIntegerValue];
        }
        
        if (i + 1 < pallete.count) {
            bottomCenter = [pallete[i + 1][0][j] unsignedIntegerValue];
            
            if (j - 1 > 0) {
                bottomLeft = [pallete[i + 1][0][j - 1] unsignedIntegerValue];
            }
            
            if (j + 1 < [pallete[i + 1][0] count]) {
                bottomRight = [pallete[i + 1][0][j + 1] unsignedIntegerValue];
            }
        }
        
        if (midleLeft == whiteIndex && midleRight == whiteIndex && (bottomLeft == whiteIndex || bottomLeft == kEraseIndex) &&
            topRight == blackIndex && topCenter == whiteIndex && topLeft == whiteIndex && bottomCenter == whiteIndex && bottomRight == whiteIndex) {
            [pallete[i][0] replaceObjectAtIndex:j withObject:[NSNumber numberWithInteger:whiteIndex]];
            needContinue = YES;
        }
        
        i --;
        j ++;
    } while (needContinue);
}


/*
 0 0 0 0
 0 1 0 0
 0 0 1 0
 0 0 0 1
 */
+ (void)fromBottomRightToTopLeft:(CGPoint)location
                         pallete:(NSMutableArray *)pallete
                      whiteIndex:(NSUInteger)whiteIndex
                      blackIndex:(NSUInteger)blackIndex
{
    int i = location.y;
    int j = location.x;
    BOOL needContinue = NO;
    do {
        needContinue = NO;
        if (j < 0 || i < 0) {
            break;
        }
        
        NSUInteger topLeft = whiteIndex;
        NSUInteger topCenter = whiteIndex;
        NSUInteger topRight = whiteIndex;
        NSUInteger midleLeft = whiteIndex;
        NSUInteger midleRight = whiteIndex;
        NSUInteger bottomCenter = whiteIndex;
        NSUInteger bottomLeft = whiteIndex;
        NSUInteger bottomRight = whiteIndex;
        
        if (i - 1 > 0) {
            if (j - 1 > 0) {
                topLeft = [pallete[i - 1][0][j - 1] unsignedIntegerValue];
            }
            
            topCenter = [pallete[i - 1][0][j] unsignedIntegerValue];
            
            if (j + 1 < [pallete[i][0] count]) {
                topRight = [pallete[i - 1][0][j + 1] unsignedIntegerValue];
            }
        }
        
        if (j - 1 > 0) {
            midleLeft = [pallete[i][0][j - 1] unsignedIntegerValue];
        }
        
        if (j + 1 < [pallete[i][0] count]) {
            midleRight = [pallete[i][0][j + 1] unsignedIntegerValue];
        }
        
        if (i + 1 < pallete.count) {
            bottomCenter = [pallete[i + 1][0][j] unsignedIntegerValue];
            
            if (j - 1 > 0) {
                bottomLeft = [pallete[i + 1][0][j - 1] unsignedIntegerValue];
            }
            
            if (j + 1 < [pallete[i + 1][0] count]) {
                bottomRight = [pallete[i + 1][0][j + 1] unsignedIntegerValue];
            }
        }
        
        if (midleLeft == whiteIndex && midleRight == whiteIndex &&
            (topRight == whiteIndex || topRight == kEraseIndex) && topCenter == whiteIndex && topLeft == blackIndex &&
            bottomCenter == whiteIndex && (bottomRight == whiteIndex || bottomRight == kEraseIndex)) {
            [pallete[i][0] replaceObjectAtIndex:j withObject:[NSNumber numberWithInteger:whiteIndex]];
            needContinue = YES;
        }
        
        i --;
        j --;
    } while (needContinue);
}

+ (NSUInteger)convertValue:(NSUInteger)value blackIndex:(NSUInteger)blackIndex
{
    if (value == kSaveValue || value == 774) {
        return blackIndex;
    }
    return value;
}


@end
