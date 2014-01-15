//
//  DrawLayerView.m
//  Lr1_MM
//
//  Created by Max Kuznetsov on 21.11.13.
//  Copyright (c) 2013 111Minutes. All rights reserved.
//

#import "DrawLayerView.h"

@interface DrawLayerView ()

@end

@implementation DrawLayerView

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColor(context, CGColorGetComponents([UIColor yellowColor].CGColor));
    
    for (int i = 0; i < self.rects.count; i++) {
        CGRect rect = [self.rects[i] CGRectValue];
        rect.origin.x -= 1;
        rect.origin.y -= 1;
        rect.size.width += 2;
        rect.size.height += 2;
        CGContextStrokeRect(context, rect);
    }
}

- (void)setRects:(NSMutableArray *)rects
{
    _rects = rects;
    [self setNeedsDisplay];
}


@end
