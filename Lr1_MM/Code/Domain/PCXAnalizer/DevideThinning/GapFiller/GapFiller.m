//
//  GapFiller.m
//  Lr1_MM
//
//  Created by Max Kuznetsov on 15.01.14.
//  Copyright (c) 2014 111Minutes. All rights reserved.
//

#import "GapFiller.h"

@interface GapFiller ()

@property (nonatomic, assign) NSUInteger whiteIndex;
@property (nonatomic, assign) NSUInteger blackIndex;
@property (nonatomic, strong) NSMutableArray *pallete;

@end

@implementation GapFiller

- (id)initWithPallete:(NSMutableArray *)pallete
           whiteIndex:(NSUInteger)whiteIndex
           blackIndex:(NSUInteger)blackIndex
{
    self = [super init];
    if (self) {
        self.pallete = pallete;
        self.whiteIndex = whiteIndex;
        self.blackIndex = blackIndex;
    }
    return self;
}


- (void)fillGapsWithDivide:(CGRect)divide
{
    for (int i = divide.origin.y; i < divide.size.height + divide.origin.y; i++) {
        for (int j = divide.origin.x; j < divide.size.width + divide.origin.x; j++) {
            NSUInteger value = [self.pallete[i][0][j] unsignedIntegerValue];
            if (value != self.whiteIndex) {
                continue;
            }
            
            NSUInteger topLeft = self.whiteIndex;
            NSUInteger topCenter = self.whiteIndex;
            NSUInteger topRight = self.whiteIndex;
            if (j - 1 > 0 && i - 1 > 0) {
                topLeft = [self.pallete[i - 1][0][j - 1] unsignedIntegerValue];
                if (j < [self.pallete[i - 1][0] count]) {
                    topCenter = [self.pallete[i - 1][0][j] unsignedIntegerValue];
                }
                
                if (j + 1 < [self.pallete[i - 1][0] count]) {
                    topRight = [self.pallete[i - 1][0][j + 1] unsignedIntegerValue];
                }
            }
            
            NSUInteger midleLeft = self.whiteIndex;
            NSUInteger bottomLeft = self.whiteIndex;
            if (j - 1 > 0) {
                midleLeft = [self.pallete[i][0][j - 1] unsignedIntegerValue];
                
                if (i + 1 < self.pallete.count) {
                    bottomLeft = [self.pallete[i + 1][0][j - 1] unsignedIntegerValue];
                }
            }
            
            NSUInteger midleRight = self.whiteIndex;
            if (j + 1 < [self.pallete[i][0] count]) {
                midleRight = [self.pallete[i][0][j + 1] unsignedIntegerValue];
            }
            
            
            NSUInteger bottomCenter = self.whiteIndex;
            NSUInteger bottomRight = self.whiteIndex;
            
            if (i + 1 < self.pallete.count) {
                if (j < [self.pallete[i - 1][0] count]) {
                    bottomCenter = [self.pallete[i + 1][0][j] unsignedIntegerValue];
                }
                
                if (j + 1 < [self.pallete[i + 1][0] count]) {
                    bottomRight = [self.pallete[i + 1][0][j + 1] unsignedIntegerValue];
                }
            }
            
            
            /*
             0 0 1
             0 0 0
             1 0 0
             */
            if (topLeft == self.whiteIndex && topCenter == self.whiteIndex && topRight == self.blackIndex &&
                midleLeft == self.whiteIndex && midleRight == self.whiteIndex &&
                bottomLeft == self.blackIndex && bottomCenter == self.whiteIndex && bottomRight == self.whiteIndex) {
                [self.pallete[i][0] replaceObjectAtIndex:j withObject:[NSNumber numberWithInteger:self.blackIndex]];
            }
            
            /*
             1 0 0
             0 0 0
             0 0 1
             */
            else if (topLeft == self.blackIndex && topCenter == self.whiteIndex && topRight == self.whiteIndex &&
                midleLeft == self.whiteIndex && midleRight == self.whiteIndex &&
                bottomLeft == self.whiteIndex && bottomCenter == self.whiteIndex && bottomRight == self.blackIndex) {
                [self.pallete[i][0] replaceObjectAtIndex:j withObject:[NSNumber numberWithInteger:self.blackIndex]];
            }

            /*
             0 0 0
             1 0 1
             0 0 0
             */
            else if (topLeft == self.whiteIndex && topCenter == self.whiteIndex && topRight == self.whiteIndex &&
                     midleLeft == self.blackIndex && midleRight == self.blackIndex &&
                     bottomLeft == self.whiteIndex && bottomCenter == self.whiteIndex && bottomRight == self.whiteIndex) {
                [self.pallete[i][0] replaceObjectAtIndex:j withObject:[NSNumber numberWithInteger:self.blackIndex]];
            }
        }
    }
}

@end
