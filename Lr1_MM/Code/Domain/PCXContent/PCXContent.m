//
//  PCXContent.m
//  Lr1_MM
//
//  Created by Max Kuznetsov on 13.10.13.
//  Copyright (c) 2013 111Minutes. All rights reserved.
//

#import "PCXContent.h"
#import "PCXHeader.h"

static NSUInteger const kUseColorPallet = 12;
static NSUInteger const kColorPalleteOffset = 769;

@interface PCXContent ()

@property (nonatomic, assign) Byte *bytes;
@property (nonatomic, assign) NSUInteger length;

@property (nonatomic, assign) NSUInteger totalBytes;
@property (nonatomic, strong) PCXHeader *pcxHeader;

@end

@implementation PCXContent

- (id)initWithBytes:(Byte *)bytes length:(NSUInteger)length pcxHeader:(PCXHeader *)pcxHeader
{
    self = [super init];
    if (self) {
        self.bytes = bytes;
        self.length = length;
        
        self.pcxHeader = pcxHeader;
        [self decode];
    }
    return self;
}

#pragma mark -
#pragma makr Decoding

- (void)decode
{
/*    int length = self.pcxHeader.bytesPerLine * self.pcxHeader.imageSize.height * self.pcxHeader.planesCount;
    Byte *b = malloc(length);
    int pt = 0;
    NSUInteger indexByte = kHeaderSize;
    while (pt < length) {
        int val = self.bytes[indexByte++] & 0xff;
        if (((val & 0xc0) >> 6) == 3) {
            int len = val & 0x3f;
            val = self.bytes[indexByte++] & 0xff;
            for (int q=0; q<len; q++) {
                b[pt++] = (Byte)val;
                if ((pt % self.pcxHeader.bytesPerLine) == 0) {
                    break;
                }
            }
        } else {
            b[pt++] = (Byte) (val & 0xff);
        }
    }

    for (int i = 0; i < length; i++) {
        Byte bb = b[i];
        NSLog(@"d = %d, c = %02x, i = %d", bb, bb, i);
    }
    
    NSLog(@"");

    NSMutableArray *arr = [NSMutableArray new];
    int src = 0;//self.pcxHeader.imageSize.height * self.pcxHeader.planesCount * self.pcxHeader.bytesPerLine;
    for (int row=0; row<self.pcxHeader.imageSize.height; row++) {
        int rowOffset = row * self.pcxHeader.planesCount * self.pcxHeader.bytesPerLine;
        for (int c = 0; c < self.pcxHeader.planesCount; c++) {
            for (int w = 0; w < self.pcxHeader.imageSize.width; w++) {
                Byte value = b[rowOffset + w];
                [arr addObject:[NSNumber numberWithInteger:value]];
            }
            rowOffset += self.pcxHeader.bytesPerLine;
        }
    }
    NSLog(@"");
    
    NSMutableArray *colorValues = [NSMutableArray new];
    NSMutableArray *pixels = [NSMutableArray new];
    for (int chanelIndex = 0, index = 0; chanelIndex < self.pcxHeader.planesCount; chanelIndex++, index += self.pcxHeader.bytesPerLine - 1) {
        [pixels removeAllObjects];
        for (int colorIndex = 0; colorIndex < self.pcxHeader.bytesPerLine; colorIndex++) {
//        for (int colorIndex = 0; colorIndex < [row count] / self.pcxHeader.planesCount; colorIndex++) {
            NSNumber *value = arr[colorIndex + index];
            [pixels addObject:value];
        }
        [colorValues addObject:pixels];
    }
    [self.pallete addObject:colorValues];*/

    // old decode
//    if (self.pcxHeader.planesCount != 1 && self.pcxHeader.planesCount != 3) {
//        NSAssert(nil, @"not supported current planes count");
//        return;
//    }
    
    self.pallete = [NSMutableArray new];
    self.totalBytes = (self.pcxHeader.planesCount * self.pcxHeader.bytesPerLine);
    
    NSUInteger indexByte = kHeaderSize;
    NSUInteger colorPalleteIndex = self.length - kColorPalleteOffset;
//#ifdef DEBUG_MOD
    for (int i = 0; i < self.length; i++) {
        Byte b = self.bytes[i];
        NSLog(@"d = %d, c = %02x, i = %d", b, b, i - 128);
    }
//#endif
    for (int rowIndex = 0; rowIndex < self.pcxHeader.imageSize.height; rowIndex ++) {
        NSMutableArray *row = [NSMutableArray new];
        for (; [row count] <= self.totalBytes;) {
//            if (indexByte >= self.length) {
//                NSLog(@"qwe");
//                return;
//            }
            
            Byte value = self.bytes[indexByte++];
            NSUInteger repeatCount = 1;
            
            if ((value & 0xC0) == 0xC0) { //0xC0 == 192
                repeatCount = value & 0x3F; // 0x3F == 63
                value = self.bytes[indexByte++];
            }
            NSLog(@"value = %d, rowSize = %d", value, [row count]);
            
//            if (!(int)value) {
//                value = self.bytes[indexByte++];
//            }
            
            if (indexByte == colorPalleteIndex && self.bytes[colorPalleteIndex] == kUseColorPallet) {
                NSLog(@"use color Pallete");
                [self decodeCollorPallet];
            }
            while (repeatCount > 0) {
                [row addObject:[NSNumber numberWithInteger:value]];
                repeatCount--;
            }

            //            if (indexByte > self.length) {
//                NSLog(@"error return");
//                return;
//            }
        }
//        indexByte += total;
//        if (rowIndex == 1) {
//            indexByte += 2;
//        } else if (rowIndex == 2) {
//            indexByte += 4;
//        }
        
//        for (int pandingIndex = 0; pandingIndex < self.pcxHeader.linePaddingSize; pandingIndex++) {
//            [row addObject:[NSNumber numberWithInteger:255]];
//        }
        
        NSMutableArray *colorValues = [NSMutableArray new];
        NSMutableArray *pixels = [NSMutableArray new];
        for (int chanelIndex = 0, index = 0; chanelIndex < self.pcxHeader.planesCount; chanelIndex++, index += self.pcxHeader.bytesPerLine - 1) {
            [pixels removeAllObjects];
//            for (int colorIndex = 0; colorIndex < self.pcxHeader.bytesPerLine; colorIndex++) {
            for (int colorIndex = 0; colorIndex < [row count] / self.pcxHeader.planesCount; colorIndex++) {
                NSNumber *value = row[colorIndex + index];
                [pixels addObject:value];
            }
            [colorValues addObject:pixels];
        }
        [self.pallete addObject:colorValues];
    }
    [self decodeCollorPallet];
    NSLog(@"");
}

- (void)decodeCollorPallet
{
    self.colorPallete = [NSMutableArray new];
    for (int colorPalleteIndex = (self.length - kColorPalleteOffset) + 1; colorPalleteIndex < self.length; colorPalleteIndex++) {
        Byte value = self.bytes[colorPalleteIndex];
        [self.colorPallete addObject:[NSNumber numberWithInteger:value]];
    }
}

#pragma mark -
#pragma mark Encoding

- (NSArray *)encode
{
    NSParameterAssert(self.pallete);
    NSParameterAssert(self.pallete.count);
    
    NSMutableArray *encodedArray = [NSMutableArray new];
    
    for (NSArray *row in self.pallete) {
        for (int index = 0; index < self.pcxHeader.planesCount; index++) {
            [encodedArray addObjectsFromArray:[self encodeArray:row[index]]];
        }
    }
    return (NSArray *)encodedArray;
}

- (NSArray *)encodeArray:(NSArray *)arrayForEncoding
{
    NSMutableArray *encodedArray = [NSMutableArray new];
    NSUInteger repeatCount = 1;
    NSNumber *value;
    NSNumber *nextValue;
    for (int i = 0; i < [arrayForEncoding count]; i++) {
        value = arrayForEncoding[i];
        nextValue = nil;
        if (i + 1 < [arrayForEncoding count]) {
            nextValue = arrayForEncoding[i + 1];
        }
        
        if (nextValue && [value compare:nextValue] == NSOrderedSame) {
            repeatCount++;
            continue;
        }
        
        if ([value integerValue] > 192 || repeatCount > 1) {
            [encodedArray addObject:[NSNumber numberWithInteger:192 + repeatCount]];
        }
        [encodedArray addObject:value];
        repeatCount = 1;
    }
    return encodedArray;
}

#pragma mark -
#pragma mark Help Methods


@end
