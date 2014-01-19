//
//  PCXDivideView.m
//  Lr1_MM
//
//  Created by Max Kuznetsov on 16.01.14.
//  Copyright (c) 2014 111Minutes. All rights reserved.
//

#import "PCXDivideView.h"
#import "PCXFile.h"
#import "PCXContent.h"



@implementation PCXDivideView

- (void)drawRect:(CGRect)rect
{
    if (CGRectContainsRect(CGRectZero, self.divide)) {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    for (int i = self.divide.origin.y, ii = 0; i < self.divide.size.height + self.divide.origin.y; i++, ii++) {
        NSArray *linePallete = self.pcxFile.pcxContent.pallete[i];
        for (int jj = 0, j = self.divide.origin.x + 1; j < self.divide.size.width + self.divide.origin.x + 1; j++, jj++) {
            UIColor *color = [self colorFromLinePallete:linePallete withIndex:j alpha:1.0f];
            [color setFill];
            CGContextFillRect(context, CGRectMake(self.frame.size.width / 2 - (self.divide.size.width / 2 - jj),
                                                  self.frame.size.height / 2 - (self.divide.size.height / 2 - ii), 1, 1));
        }
    }
    
    CGImageRef imgRef = CGBitmapContextCreateImage(context);
    self.image = [UIImage imageWithCGImage:imgRef];
    CGPoint origin = CGPointMake(self.frame.size.width / 2 - (self.divide.size.width / 2),
                                 self.frame.size.height / 2 - (self.divide.size.height / 2));
    self.image = [self getSubImage:CGRectMake(origin.x, origin.y, self.divide.size.width, self.divide.size.height) image:self.image];
    CGImageRelease(imgRef);
}

- (UIImage *)getSubImage:(CGRect)rect image:(UIImage *)image
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    CGRect smallBounds = CGRectMake(rect.origin.x, rect.origin.y, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImg = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return smallImg;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if (self.touchBlock) {
        self.touchBlock([[touches allObjects] lastObject]);
    }
}

- (void)setDivide:(CGRect)divide
{
    _divide = divide;
    [self setNeedsDisplay];
}

@end
