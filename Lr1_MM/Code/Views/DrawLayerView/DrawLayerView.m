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

- (id)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColor(context, CGColorGetComponents([UIColor yellowColor].CGColor));
    for (int i = 0; i < self.rects.count; i++) {
        CGRect rect = [self.rects[i] CGRectValue];
        CGContextStrokeRect(context, rect);
    }
}

- (void)setRects:(NSMutableArray *)rects
{
    _rects = rects;
    [self setNeedsDisplay];
}


@end
