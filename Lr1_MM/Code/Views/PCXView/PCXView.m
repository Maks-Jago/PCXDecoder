//
//  PCXView.m
//  Lr1_MM
//
//  Created by Max Kuznetsov on 13.10.13.
//  Copyright (c) 2013 111Minutes. All rights reserved.
//

#import "PCXView.h"
#import "PCXFile.h"

#import <QuartzCore/CoreAnimation.h>

@interface PCXView ()

@property (nonatomic, strong) PCXFile *pcxFile;

@end

@implementation PCXView

+ (Class)layerClass
{
    return [CATiledLayer class];
}

#pragma mark -
#pragma mark Initializations

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
	if (self) {
		CATiledLayer *animLayer = (CATiledLayer *)self.layer;
		animLayer.levelsOfDetailBias = 4;
		animLayer.levelsOfDetail = 4;
	}
	return self;
}

- (id)initWithPCXFile:(PCXFile *)pcxFile
{
    self = [super init];
    if (self) {
        self.pcxFile = pcxFile;
        self.editedColor = [UIColor blackColor];
    }
    return self;
}

#pragma mark -
#pragma mark View Managment

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (int i = 0; i < self.pcxFile.pcxHeader.imageSize.height; i++) {
        CGContextMoveToPoint(context, 0, i);
        NSArray *linePallete = self.pcxFile.pcxContent.pallete[i];
        for (int j = 0; j < self.pcxFile.pcxHeader.bytesPerLine; j++) {
            UIColor *color = [self colorFromLinePallete:linePallete withIndex:j alpha:1.0f];
            [color setFill];
            CGContextFillRect(context, CGRectMake(j, i, 1, 1));
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSArray *touchesArray = [touches allObjects];
    if ([touchesArray count] && !self.tag) {
        UITouch *touch = [touches allObjects][0];
        if (touch.tapCount == 1) {
            CGPoint location = [touch locationInView:self];
            NSUInteger roundedX = RoundFloat(location.x);
            NSUInteger roundedY = RoundFloat(location.y);

            if ((NSUInteger)location.x >= [self.pcxFile.pcxContent.pallete count]) {
                return;
            }
            
            NSMutableArray *mutArray = self.pcxFile.pcxContent.pallete[roundedY];
            for (int index = 0; index < [mutArray count]; index ++) {
                NSMutableArray *array = mutArray[index];
                [array replaceObjectAtIndex:roundedX withObject:[NSNumber numberWithInteger:0]];
            }
            [self setNeedsDisplayInRect:CGRectMake(roundedX, roundedY, 1, 1)];
//            [self setNeedsDisplay];
        }
    }
}

#pragma mark -
#pragma mark Help Methods

- (UIColor *)colorFromLinePallete:(NSArray *)linePallete withIndex:(NSUInteger)index alpha:(CGFloat)alpha
{
    UIColor *color = nil;
    NSUInteger linePalleteCount = [linePallete count];
    switch (linePalleteCount) {
        case 1: {
            CGFloat grayScaleValue = [linePallete[0][index] floatValue];
#ifdef DEBUG_MOD
            NSLog(@"gray scale = %f", grayScaleValue);
#endif
            color = [UIColor colorWithWhite:grayScaleValue alpha:alpha];
        }
            break;
        case 3: {
            CGFloat red = [linePallete[0][index] floatValue];
            CGFloat green = [linePallete[1][index] floatValue];
            CGFloat blue = [linePallete[2][index] floatValue];

#ifdef DEBUG_MOD
            NSLog(@"red = %f, green = %f, blue = %f", red, green, blue);
#endif
            color = RGBA(red, green, blue, alpha);
        }
            break;
        default:
            NSAssert(nil, @"not supported this channel bits count");
            break;
    }
    return color;
}

@end
