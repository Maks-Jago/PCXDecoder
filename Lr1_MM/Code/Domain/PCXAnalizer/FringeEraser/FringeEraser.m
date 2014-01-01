//
//  FringeEraser.m
//  Lr1_MM
//
//  Created by Max Kuznetsov on 29.12.13.
//  Copyright (c) 2013 111Minutes. All rights reserved.
//

#import "FringeEraser.h"
#import "LeftAperture.h"
#import "TopAperture.h"
#import "RightAperture.h"
#import "BottomAperture.h"

@interface FringeEraser ()

@property (nonatomic, strong) PCXContent *pcxContent;

@property (nonatomic, strong) LeftAperture *leftAperture;
@property (nonatomic, strong) TopAperture *topAperture;
@property (nonatomic, strong) RightAperture *rightAperture;
@property (nonatomic, strong) BottomAperture *bottomAperture;

@property (nonatomic, strong) NSMutableArray *palleteCopy;

@end

@implementation FringeEraser

- (id)initWithPCXContent:(PCXContent *)pcxContent
{
    self = [super init];
    if (self) {
        self.pcxContent = pcxContent;
        self.topAperture = [TopAperture new];        
        self.leftAperture = [LeftAperture new];
        self.rightAperture = [RightAperture new];
        self.bottomAperture = [BottomAperture new];
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
    _whiteIndex = whiteIndex;
    self.topAperture.whiteIndex = whiteIndex;
    self.leftAperture.whiteIndex = whiteIndex;
    self.rightAperture.whiteIndex = whiteIndex;
    self.bottomAperture.whiteIndex = whiteIndex;
}

- (void)setBlackIndex:(NSUInteger)blackIndex
{
    _blackIndex = blackIndex;
    self.topAperture.blackIndex = blackIndex;
    self.leftAperture.blackIndex = blackIndex;
    self.rightAperture.blackIndex = blackIndex;
    self.bottomAperture.blackIndex = blackIndex;
}

- (void)eraseFringe
{
    NSMutableArray *rows = self.pcxContent.pallete;
    if (self.useCopy) {
        [self createPalleteCopy];
        rows = self.palleteCopy;
    }
    
    if (!rows.count) {
        NSLog(@"FringeEraser: rowsCount == 0");
        return;
    }
    
    for (int i = 1; i < rows.count - 1; i ++) {
        NSMutableArray *row = rows[i][0];
        for (int j = 1; j < row.count - 1; j++) {
            BOOL isFringe = YES;
            if (![self.topAperture isPixelEqualToAperture:rows rowsIndex:i rowIndex:j]) {
                if (![self.leftAperture isPixelEqualToAperture:rows rowsIndex:i rowIndex:j]) {
                    if (![self.rightAperture isPixelEqualToAperture:rows rowsIndex:i rowIndex:j]) {
                        if (![self.bottomAperture isPixelEqualToAperture:rows rowsIndex:i rowIndex:j]) {
                            isFringe = NO;
                        }
                    }
                }
            }
            
            if (isFringe) {
                NSUInteger value = self.whiteIndex;
#if FRINGE_ERASER_DEBUG
                value = 777;
#endif
                if (self.useCopy) {
                    [self.pcxContent.pallete[i][0] replaceObjectAtIndex:j withObject:[NSNumber numberWithInteger:value]];
                } else {
                    [row replaceObjectAtIndex:j withObject:[NSNumber numberWithInteger:value]];
                }
            }
        }
    }
}

@end
