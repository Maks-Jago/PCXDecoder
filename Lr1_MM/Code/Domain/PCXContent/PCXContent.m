//
//  PCXContent.m
//  Lr1_MM
//
//  Created by Max Kuznetsov on 13.10.13.
//  Copyright (c) 2013 111Minutes. All rights reserved.
//

#import "PCXContent.h"
#import "PCXHeader.h"

@interface PCXContent ()

@property (nonatomic, assign) Byte* bytes;
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
        [self encode];
    }
    return self;
}

- (void)decode
{
    if (self.pcxHeader.planesCount != 1 && self.pcxHeader.planesCount != 3) {
        NSAssert(nil, @"not supported current planes count");
        return;
    }
    
    self.pallete = [NSMutableArray new];
    self.totalBytes = self.pcxHeader.planesCount * self.pcxHeader.bytesPerLine;
    
    NSUInteger indexByte = kHeaderSize;
#ifdef DEBUG_MOD
    for (int i = indexByte; i < self.length; i++) {
        Byte b = self.bytes[i];
        NSLog(@"d = %d, c = %02x, i = %d", b, b, i);
    }
#endif
    for (int rowIndex = 0; rowIndex < self.pcxHeader.imageSize.height; rowIndex ++) {
        NSMutableArray *row = [NSMutableArray new];
        for (int pixelIndex = 0; pixelIndex < self.totalBytes; pixelIndex++) {
            Byte value = self.bytes[indexByte++];
            NSUInteger repeatCount = 1;
            
            if ((value & 192) == 192) { //0xC0 == 192
                repeatCount = value - 192; // 0x3F == 63
                value = self.bytes[indexByte++];
            }
            while (repeatCount > 0) {
                [row addObject:[NSNumber numberWithInteger:value]];
                repeatCount--;
            }
        }
        
        NSMutableArray *colorValues = [NSMutableArray new];
        NSMutableArray *pixels = [NSMutableArray new];
        for (int chanelIndex = 0, index = 0; chanelIndex < self.pcxHeader.planesCount; chanelIndex++, index += self.pcxHeader.bytesPerLine) {
            [pixels removeAllObjects];
            for (int colorIndex = 0; colorIndex < self.pcxHeader.bytesPerLine; colorIndex++) {
                NSNumber *value = row[colorIndex + index];
                [pixels addObject:value];
            }
            [colorValues addObject:pixels];
        }
        
        [self.pallete addObject:colorValues];
    }
}

- (NSArray *)encode
{
    NSParameterAssert(self.pallete);
    NSParameterAssert(self.pallete.count);
    
    NSMutableArray *encodedArray = [NSMutableArray new];
    
    for (NSArray *row in self.pallete) {
        [encodedArray addObjectsFromArray:[self encodeArray:row[0]]];
        [encodedArray addObjectsFromArray:[self encodeArray:row[1]]];
        [encodedArray addObjectsFromArray:[self encodeArray:row[2]]];
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
        if (i + 1 < [arrayForEncoding count]) {
            nextValue = arrayForEncoding[i + 1];
        } else {
            nextValue = nil;
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

/*- (void)startDecoding
{
    self.mutablePallete = [NSMutableArray new];
    self.totalBytes = self.pcxHeader.planesCount * self.pcxHeader.bytesPerLine;

    for (int i = 128; i < self.length; i++) {
        Byte b = self.bytes[i];
        NSLog(@"d = %d, c = %02x, i = %d", b, b, i);   
    }

    int indexByte = 128;
    self.decodedBytes = malloc(self.pcxHeader.imageSize.height * self.totalBytes);
    NSUInteger total = 0;
    for (int rowIndex = 0; rowIndex < self.pcxHeader.imageSize.height; rowIndex ++) {
        NSArray *row = [self decodeLineWithIndexByte:indexByte];
        
        for (int decodedIndex = 0; decodedIndex < self.pcxHeader.imageSize.width; decodedIndex++) {
            self.decodedBytes[total + 3 * decodedIndex] = [row[decodedIndex] integerValue];
            self.decodedBytes[total + 3 * decodedIndex + 1] = [row[decodedIndex + self.pcxHeader.bytesPerLine] integerValue];
            self.decodedBytes[total + 3 * decodedIndex + 2] = [row[decodedIndex + (self.pcxHeader.bytesPerLine << 1)] integerValue];
        }
        
        self.decodedBytes += self.pcxHeader.bytesPerLine;
        total += self.totalBytes;
        indexByte += self.totalBytes;
//        [self.mutablePallete addObject:row];
    }
    NSLog(@"");
}*/

//- (NSArray *)decodeLineWithIndexByte:(int )indexByte
//{
//    NSMutableArray *row = [NSMutableArray new];
//    for (int pixelIndex = 0; pixelIndex < self.totalBytes; pixelIndex++) {
//        Byte value = self.bytes[indexByte++];
//        if ((value & 192) == 192) { //0xC0 == 192
//            NSUInteger repeatCount = value & 63; // 0x3F == 63
//            value = self.bytes[indexByte++];
//            while (repeatCount > 0) {
//                [row addObject:[NSNumber numberWithInteger:value]];
//                repeatCount--;
//            }
//        } else {
//            [row addObject:[NSNumber numberWithInteger:value]];
//        }
//    }
//    return (NSArray *)row;
//}

#pragma mark -
#pragma mark Help Methods


@end
