//
//  PCXView.m
//  Lr1_MM
//
//  Created by Max Kuznetsov on 13.10.13.
//  Copyright (c) 2013 111Minutes. All rights reserved.
//

#import "PCXView.h"
#import "PCXFile.h"

@interface PCXView ()

@property (nonatomic, strong) PCXFile *pcxFile;

@end

@implementation PCXView

- (id)initWithPCXFile:(PCXFile *)pcxFile
{
    self = [super init];
    if (self) {
        self.pcxFile = pcxFile;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (int i = 0; i < self.pcxFile.pcxHeader.imageSize.height; i++) {
        CGContextMoveToPoint(context, 0, i);
        NSArray *linePallete = self.pcxFile.pcxContent.pallete[i];
        for (int j = 0; j < self.pcxFile.pcxHeader.bytesPerLine; j++) {
            CGFloat red = [linePallete[0][j] floatValue];
            CGFloat green = [linePallete[1][j] floatValue];
            CGFloat blue = [linePallete[2][j] floatValue];
            
//            NSLog(@"red = %f, green = %f, blue = %f", red, green, blue);
            UIColor *color = [UIColor colorWithRed:red / 255.0f
                                             green:green / 255.0f
                                              blue:blue / 255.0f
                                             alpha:1.0f];
            [color setFill];
            CGContextFillRect(context, CGRectMake(j, i, 1, 1));
        }
    }
}

/*- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    NSUInteger total = 0;
    for (int i = 0; i < self.pcxFile.pcxHeader.imageSize.height; i++) {
        CGContextMoveToPoint(context, 0, i);
//        NSArray *linePallete = self.pcxFile.pcxContent.pallete[i];
        for (int j = 0; j < self.pcxFile.pcxHeader.totalBytes; j+= 3) {
            CGFloat red = self.pcxFile.pcxContent.decodedBytes[total + j];//[linePallete[j] floatValue];
            CGFloat green = self.pcxFile.pcxContent.decodedBytes[total + j + 1];//[linePallete[j + self.pcxFile.pcxHeader.bytesPerLine] floatValue];
            CGFloat blue = self.pcxFile.pcxContent.decodedBytes[total + j + 2];//[linePallete[j + (self.pcxFile.pcxHeader.bytesPerLine << 1)] floatValue];

            NSLog(@"red = %f, green = %f, blue = %f", red, green, blue);
            UIColor *color = [UIColor colorWithRed:red / 255.0f
                                             green:green / 255.0f
                                              blue:blue / 255.0f
                                             alpha:1.0f];
            [color setFill];
            CGContextFillRect(context, CGRectMake(j / 3, i, 1, 1));
        }
        total += self.pcxFile.pcxHeader.totalBytes;
    }
}*/

@end
