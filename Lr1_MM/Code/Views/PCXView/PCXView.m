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
        for (int j = 0; j < self.pcxFile.pcxHeader.totalBytes / 3; j++) {
            CGFloat red = [linePallete[j] floatValue];
            CGFloat green = [linePallete[j + self.pcxFile.pcxHeader.bytesPerLine] floatValue];
            CGFloat blue = [linePallete[j + (self.pcxFile.pcxHeader.bytesPerLine << 1)] floatValue];

            UIColor *color = [UIColor colorWithRed:red / 255.0f
                                             green:green / 255.0f
                                              blue:blue / 255.0f
                                             alpha:1.0f];
            [color setFill];
            CGContextFillRect(context, CGRectMake(j, i, 1, 1));
        }
    }
}

@end
