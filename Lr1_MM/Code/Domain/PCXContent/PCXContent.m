//
//  PCXContent.m
//  Lr1_MM
//
//  Created by Max Kuznetsov on 13.10.13.
//  Copyright (c) 2013 111Minutes. All rights reserved.
//

#import "PCXContent.h"
#import "PCXHeader.h"
#include "pcx.h"

@interface PCXContent ()

@property (nonatomic, strong) NSMutableArray *mutablePallete;
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
        [self startDecoding];
    }
    return self;
}

- (NSArray *)pallete
{
    return (NSArray *)self.mutablePallete;
}

- (void)startDecoding
{
    self.mutablePallete = [NSMutableArray new];
    self.totalBytes = self.pcxHeader.planesCount * self.pcxHeader.bytesPerLine;

    NSUInteger indexByte = 128;
    for (int i = 128; i < self.length; i++) {
        Byte b = self.bytes[i];
        NSLog(@"d = %d, c = %02x, i = %d", b, b, i);   
    }
    
    for (int rowIndex = 0; rowIndex < self.pcxHeader.imageSize.height; rowIndex ++) {
        NSMutableArray *row = [NSMutableArray new];
        for (int pixelIndex = 0; pixelIndex < self.totalBytes; pixelIndex++) {
            Byte value = self.bytes[indexByte++];
            if ((value & 192) == 192) { //0xC0 == 192
                NSUInteger repeatCount = value & 63; // 0x3F == 63
                value = self.bytes[indexByte++];
                while (repeatCount > 0) {
                    [row addObject:[NSNumber numberWithInteger:value]];
                    repeatCount--;
                }
            } else {
                [row addObject:[NSNumber numberWithInteger:value]];
            }
        }
        [self.mutablePallete addObject:row];
    }
    NSLog(@"");
}

#pragma mark -
#pragma mark Help Methods


@end
