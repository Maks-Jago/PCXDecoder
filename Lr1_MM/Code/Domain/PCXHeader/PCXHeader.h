//
//  PCXHeader.h
//  Lr1_MM
//
//  Created by Max Kuznetsov on 14.10.13.
//  Copyright (c) 2013 111Minutes. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSUInteger const kHeaderSize = 128;

@interface PCXHeader : NSObject

/** information properties*/
@property (nonatomic, readonly) NSUInteger pcxFlag;
@property (nonatomic, readonly) NSUInteger version;
@property (nonatomic, readonly) NSUInteger encoding;
@property (nonatomic, readonly) NSUInteger bitsPerPixel;
/** end*/

@property (nonatomic, readonly) CGRect window;              // origin.x - Xmin, origin.y - Ymin, size.width - Xmax, size.heigh - Ymax
@property (nonatomic, readonly) CGSize screenSize;
@property (nonatomic, readonly) NSArray *colorMap;          // NSNumber (integer 0..255)
@property (nonatomic, readonly) NSUInteger reservedByte;
@property (nonatomic, readonly) NSUInteger planesCount;
@property (nonatomic, readonly) NSUInteger bytesPerLine;
@property (nonatomic, readonly) NSUInteger palleteInfo;

- (id)initWithBytes:(Byte *)bytes;

- (void)logHeader;
- (CGSize)imageSize;
- (NSUInteger)totalBytes;
- (CGFloat)linePaddingSize;

@end
