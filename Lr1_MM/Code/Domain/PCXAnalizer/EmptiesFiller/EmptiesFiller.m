//
//  EmptiesFiller.m
//  Lr1_MM
//
//  Created by Max Kuznetsov on 28.12.13.
//  Copyright (c) 2013 111Minutes. All rights reserved.
//

#import "EmptiesFiller.h"
#import "NSArray+LogMatr.h"

@interface EmptiesFiller ()

@property (nonatomic, strong) PCXContent *pcxContent;
@property (nonatomic, strong) NSMutableArray *palleteCopy;

@end

@implementation EmptiesFiller

- (id)initWithPCXContent:(PCXContent *)pcxContent
{
    self = [super init];
    if (self) {
        self.pcxContent = pcxContent;
    }
    return self;
}

- (void)fillEmpties
{
    [self createPalleteCopy];
    
    NSMutableArray *rows = self.palleteCopy;
    for (int i = 0; i < rows.count; i ++) {
        NSMutableArray *row = rows[i][0];
        for (int j = 0; j < row.count; j++) {
            NSInteger pixel = [row[j] integerValue];
            if (pixel == self.whiteIndex / 3) {
                if ([self isNeedFillPixelWithRowsIndex:i rowIndex:j row:row]) {
                    NSUInteger value = self.blackIndex / 3;
#if EMPTIES_FILLER_DEBUG
                    value = 776;
#endif
//                    [row replaceObjectAtIndex:j withObject:[NSNumber numberWithInteger:value]];
                    [self.pcxContent.pallete[i][0] replaceObjectAtIndex:j withObject:[NSNumber numberWithInteger:value]];
                }
            }
        }
    }
    
//    self.pcxContent.pallete = [NSMutableArray arrayWithArray:rows];
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


- (BOOL)isNeedFillPixelWithRowsIndex:(NSUInteger)rowsIndex rowIndex:(NSUInteger)rowIndex row:(NSArray *)row
{
    NSUInteger blackPixelsCount = 0;
    NSArray *rowCopy = [NSArray arrayWithArray:row];
    blackPixelsCount = [self analizeRow:rowCopy withBlackPixelsCount:blackPixelsCount rowIndex:rowIndex];
    
    if (rowsIndex - 1 < self.palleteCopy.count) {
        rowCopy = self.palleteCopy[rowsIndex - 1][0];
        blackPixelsCount = [self analizeRow:rowCopy withBlackPixelsCount:blackPixelsCount rowIndex:rowIndex];
        if ([row[rowIndex] integerValue] == self.blackIndex / 3) {
            blackPixelsCount ++;
        }
        
    }
    
    if (rowsIndex + 1 < self.palleteCopy.count) {
        rowCopy = self.palleteCopy[rowsIndex + 1][0];
        blackPixelsCount = [self analizeRow:rowCopy withBlackPixelsCount:blackPixelsCount rowIndex:rowIndex];
        if ([row[rowIndex] integerValue] == self.blackIndex / 3) {
            blackPixelsCount ++;
        }
    }
    
    return blackPixelsCount >= 5;
}

- (NSUInteger)analizeRow:(NSArray *)row withBlackPixelsCount:(NSUInteger)blackPixelsCount rowIndex:(NSUInteger)rowIndex
{
    blackPixelsCount = [self incrementCount:blackPixelsCount item:row[rowIndex]];
    
    if (rowIndex - 1 < row.count) {
        blackPixelsCount = [self incrementCount:blackPixelsCount item:row[rowIndex - 1]];
    }
    
    if (rowIndex + 1 < row.count) {
        blackPixelsCount = [self incrementCount:blackPixelsCount item:row[rowIndex + 1]];
    }
    return blackPixelsCount;
}

- (NSUInteger)incrementCount:(NSUInteger)index item:(NSNumber *)item
{
    if ([item integerValue] == self.blackIndex / 3) {
        return index + 1;
    }
    return index;
}


@end
