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

@interface FringeEraser ()

@property (nonatomic, strong) PCXContent *pcxContent;
@property (nonatomic, strong) LeftAperture *leftAperture;
@property (nonatomic, strong) TopAperture *topAperture;

@end

@implementation FringeEraser

- (id)initWithPCXContent:(PCXContent *)pcxContent
{
    self = [super init];
    if (self) {
        self.pcxContent = pcxContent;
        self.topAperture = [TopAperture new];        
        self.leftAperture = [LeftAperture new];
    }
    return self;
}

- (void)setWhiteIndex:(NSUInteger)whiteIndex
{
    _whiteIndex = whiteIndex;
    self.topAperture.whiteIndex = whiteIndex;
    self.leftAperture.whiteIndex = whiteIndex;
}

- (void)setBlackIndex:(NSUInteger)blackIndex
{
    _blackIndex = blackIndex;
    self.topAperture.blackIndex = blackIndex;
    self.leftAperture.blackIndex = blackIndex;
}

- (void)eraseFringe
{
    NSMutableArray *rows = self.pcxContent.pallete;
    if (!rows.count) {
        NSLog(@"FringeEraser: rowsCount == 0");
        return;
    }
    
    for (int i = 1; i < rows.count - 1; i ++) {
        NSMutableArray *row = rows[i][0];
        for (int j = 1; j < row.count - 1; j++) {
            if ([self.topAperture isPixelEqualToAperture:rows rowsIndex:i rowIndex:j]) {
                NSUInteger value = self.blackIndex;
#ifdef FRINGE_ERASER_DEBUG
                value = 777;
#endif
                [row replaceObjectAtIndex:j withObject:[NSNumber numberWithInteger:value]];
            }
        }
    }
}

@end
