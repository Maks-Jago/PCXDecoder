//
//  PCXHeader.m
//  Lr1_MM
//
//  Created by Max Kuznetsov on 14.10.13.
//  Copyright (c) 2013 111Minutes. All rights reserved.
//

#import "PCXHeader.h"

/*
 //Header content
 PCX Flag         1    Constant flag
 Version          1    PCX version number   // 0 - version 2.5, 2 - 2.8 with pallete, 3 - 2.8 without pallete, 5 - 3.0
 Encoding         1    Run-length encoding flag
 Bits per Pixel   1    Number of bits per pixel per plane
 Window           8    Window dimensions
 HDPI             2    Horizontal image resolution
 VDPI             2    Vertical image resolution
 Color Map       48    Hardware R-G-B color palette
 Reserved         1    (Used to contain video mode)
 NPlanes          1    Number of color planes
 Bytes per Line   2    Number of bytes per scan line
 Palette Info     2    Palette interpretation
 HScreen Size     2    Horizontal screen size
 VScreen Size     2    Vertical screen size
 Filler          54    Initialized filler bytes
 */

//        NSLog(@"d = %d, c = %02x, i = %d", b, b, i);

typedef enum {
    PCXHeaderContentPCXFlagOffset = 0,
    PCXHeaderContentVersionOffset = 1,
    PCXHeaderContentEncodingOffset = 2,
    PCXHeaderContentBitsPerPixelOffset = 3,
    PCXHeaderContentWindowOffset = 4,
    PCXHeaderContentScreenOffset = 12,
    PCXHeaderContentColorMapOffset = 16,
    PCXHeaderContentReservedOffset = 64,
    PCXHeaderContentPlanesCountOffsets = 65,
    PCXHeaderContentBytesPerLineOffsets = 66,
    PCXHeaderContentPalleteInfoOffsets = 68,
} PCXHeaderContentOffsets;


@interface PCXHeader ()

@property (nonatomic, readwrite, assign) NSUInteger pcxFlag;
@property (nonatomic, readwrite, assign) NSUInteger version;
@property (nonatomic, readwrite, assign) NSUInteger encoding;
@property (nonatomic, readwrite, assign) NSUInteger bitsPerPixel;
@property (nonatomic, readwrite, assign) CGRect window;
@property (nonatomic, readwrite, assign) CGSize screenSize;
@property (nonatomic, readwrite, strong) NSArray *colorMap;
@property (nonatomic, readwrite, assign) NSUInteger reservedByte;
@property (nonatomic, readwrite, assign) NSUInteger planesCount;
@property (nonatomic, readwrite, assign) NSUInteger bytesPerLine;
@property (nonatomic, readwrite, assign) NSUInteger palleteInfo;

@property (nonatomic, assign) Byte *headerBytes;

@end

@implementation PCXHeader

- (id)initWithBytes:(Byte *)bytes
{
    self = [super init];
    if (self) {
        self.headerBytes = malloc(kHeaderSize);
        memcpy(self.headerBytes, bytes, kHeaderSize);
        [self decodeHeader];
    }
    return self;
}

- (void)dealloc
{
    free(self.headerBytes);
}

- (void)decodeHeader
{
    [self decodeInformationProperties];
    [self decodeWindow];
    [self decodeScreenSize];
    [self decodeColorMap];
    
    self.reservedByte = self.headerBytes[PCXHeaderContentReservedOffset];
    self.planesCount = self.headerBytes[PCXHeaderContentPlanesCountOffsets];
    self.bytesPerLine = UIIntegerFromBytes(self.headerBytes[PCXHeaderContentBytesPerLineOffsets],
                                           self.headerBytes[PCXHeaderContentBytesPerLineOffsets + 1]);
    
    self.palleteInfo = UIIntegerFromBytes(self.headerBytes[PCXHeaderContentPalleteInfoOffsets],
                                          self.headerBytes[PCXHeaderContentPalleteInfoOffsets + 1]);
#ifdef DEBUG_MOD
    [self logHeader];
#endif
}

#pragma mark -
#pragma mark Decode Methods

- (void)decodeInformationProperties
{
    self.pcxFlag = self.headerBytes[PCXHeaderContentPCXFlagOffset];
    self.version = self.headerBytes[PCXHeaderContentVersionOffset];
    self.encoding = self.headerBytes[PCXHeaderContentEncodingOffset];
    self.bitsPerPixel = self.headerBytes[PCXHeaderContentBitsPerPixelOffset];
}

- (void)decodeWindow
{
    NSUInteger windowOffset = PCXHeaderContentWindowOffset;
    NSUInteger originX = UIIntegerFromBytes(self.headerBytes[windowOffset++], self.headerBytes[windowOffset++]);
    NSUInteger originY = UIIntegerFromBytes(self.headerBytes[windowOffset++], self.headerBytes[windowOffset++]);
    NSUInteger sizeWidth = UIIntegerFromBytes(self.headerBytes[windowOffset++], self.headerBytes[windowOffset++]);
    NSUInteger sizeHeight = UIIntegerFromBytes(self.headerBytes[windowOffset++], self.headerBytes[windowOffset++]);
    
    self.window = CGRectMake(originX, originY, sizeWidth, sizeHeight);
}

- (void)decodeScreenSize
{
    NSUInteger screenOffset = PCXHeaderContentScreenOffset;
    NSUInteger screenWidth = UIIntegerFromBytes(self.headerBytes[screenOffset++], self.headerBytes[screenOffset++]);
    NSUInteger screenHeight = UIIntegerFromBytes(self.headerBytes[screenOffset++], self.headerBytes[screenOffset++]);

    self.screenSize = CGSizeMake(screenWidth, screenHeight);
}

- (void)decodeColorMap
{
    static NSUInteger const kColorMapSize = 48;
    NSMutableArray *mutablePallete = [NSMutableArray new];
    for (int i = PCXHeaderContentColorMapOffset; i < PCXHeaderContentColorMapOffset + kColorMapSize ; i++) {
        NSUInteger byteValue = self.headerBytes[i];
        [mutablePallete addObject:[NSNumber numberWithUnsignedInteger:byteValue]];
    }
    self.colorMap = [NSArray arrayWithArray:mutablePallete];
}

#pragma mark -
#pragma mark Help Methods


- (NSUInteger)totalBytes
{
    return self.planesCount * self.bytesPerLine;
}

- (CGSize)imageSize
{
    CGSize size = CGSizeMake(self.window.size.width - self.window.origin.x + 1, self.window.size.height - self.window.origin.y + 1);
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        size = self.screenSize;
    }
    return size;
}

- (CGFloat)linePaddingSize
{
    return ((self.bytesPerLine * self.planesCount) * (8 / self.bitsPerPixel)) - ((self.window.size.width - self.window.origin.x) + 1);
}

- (void)logHeader
{
    NSMutableString *loggedString = [NSMutableString new];
    [loggedString appendFormat:@"\n\n-----<PCXHeader>------\n\npcxFlag = %lu\n", (unsigned long)self.pcxFlag];
    [loggedString appendFormat:@"version = %lu\n", (unsigned long)self.version];
    [loggedString appendFormat:@"encoding = %lu\n", (unsigned long)self.version];
    [loggedString appendFormat:@"bitsPerPixel = %lu\n", (unsigned long)self.bitsPerPixel];
    [loggedString appendFormat:@"\nwindow:\nXmin = %f\nYmin = %f\nXmax = %f\nYmax = %f\n", self.window.origin.x, self.window.origin.y, self.window.size.width, self.window.size.height];
    [loggedString appendFormat:@"\nscreenSize:\nwidth = %f\nheigh = %f\n\n", self.screenSize.width, self.screenSize.height];
    [loggedString appendString:@"colorMap:\n"];
    
    for (NSNumber *colorValue in self.colorMap) {
        [loggedString appendFormat:@"%lu, ", [colorValue unsignedIntegerValue]];
    }
    
    [loggedString appendFormat:@"\nreservedByte = %lu\n", (unsigned long)self.reservedByte];
    [loggedString appendFormat:@"planesCount = %lu\n", (unsigned long)self.planesCount];
    [loggedString appendFormat:@"bytesPerLine = %lu\n", (unsigned long)self.bytesPerLine];
    [loggedString appendFormat:@"palleteInfo = %lu\n", (unsigned long)self.palleteInfo];
    
    NSLog(@"%@\n", loggedString);
}

@end




