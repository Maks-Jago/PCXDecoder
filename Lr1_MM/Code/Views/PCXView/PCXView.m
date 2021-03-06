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

@property (nonatomic, assign) NSValue *firstDivider;

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

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!self.drawLayerView.superview) {
        self.drawLayerView = [[DrawLayerView alloc] initWithFrame:self.bounds];
        self.drawLayerView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.drawLayerView];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches.allObjects lastObject];
    CGPoint location = [touch locationInView:self];
    
    for (NSValue *value in self.drawLayerView.rects) {
        CGRect divider = [value CGRectValue];
        if (CGRectContainsPoint(divider, location)) {
            self.firstDivider = value;
            break;
        }
    }
}

#pragma mark -
#pragma mark View Managment

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (int i = 0; i < self.pcxFile.pcxContent.pallete.count - 1; i++) {
        NSArray *linePallete = self.pcxFile.pcxContent.pallete[i];
        NSUInteger count = [linePallete[0] isKindOfClass:[NSArray class]] ? [linePallete[0] count] : [linePallete count];
        for (int j = 0; j < count; j++) {
            UIColor *color = [self colorFromLinePallete:linePallete withIndex:j alpha:1.0f];
            [color setFill];
            CGContextFillRect(context, CGRectMake(j, i, 1, 1));
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches.allObjects lastObject];
    
    if (self.touchBlock) {
        self.touchBlock(touch);
    }
    
    if (!self.firstDivider) {
        return;
    }
    
    CGPoint location = [touch locationInView:self];
    
    if (!CGRectContainsPoint([self.firstDivider CGRectValue], location)) {
        for (NSValue *value in self.drawLayerView.rects) {
            CGRect divider = [value CGRectValue];
            if (CGRectContainsPoint(divider, location)) {
                NSMutableArray *arr = [NSMutableArray arrayWithArray:self.drawLayerView.rects];
                NSUInteger index = [self.drawLayerView.rects indexOfObject:value];
//                [arr removeObjectAtIndex:index];

                CGRect newDivider;
                CGRect firstDiv = [self.firstDivider CGRectValue];
                
                newDivider.origin.x = firstDiv.origin.x < divider.origin.x ? firstDiv.origin.x : divider.origin.x;
                newDivider.origin.y = firstDiv.origin.y < divider.origin.y ? firstDiv.origin.y : divider.origin.y;
                newDivider.size.height = firstDiv.size.height > divider.size.height ? firstDiv.size.height : divider.size.height;
                newDivider.size.width = firstDiv.size.width > divider.size.width ? firstDiv.size.width : divider.size.width;

                if (CGRectGetMaxX(divider) > CGRectGetMaxX(newDivider)) {
                    newDivider.size.width += fabsf(CGRectGetMaxX(divider) - CGRectGetMaxX(newDivider));
                }

                if (CGRectGetMaxY(divider) > CGRectGetMaxY(newDivider)) {
                    newDivider.size.height += fabsf(CGRectGetMaxY(divider) - CGRectGetMaxY(newDivider));
                }
                
//                [arr addObject:[NSValue valueWithCGRect:newDivider]];
//                [arr insertObject: atIndex:index - 2];
                [arr replaceObjectAtIndex:index withObject:[NSValue valueWithCGRect:newDivider]];
                [arr removeObject:self.firstDivider];
                self.firstDivider = nil;
                [self.pcxAnalizer setDivides:arr];
                [self.drawLayerView setRects:arr];
                break;
            }
        }
    }
//    NSArray *touchesArray = [touches allObjects];
//    if ([touchesArray count] && !self.tag) {
//        UITouch *touch = [touches allObjects][0];
//        if (touch.tapCount == 1) {
//            CGPoint location = [touch locationInView:self];
//            NSUInteger roundedX = RoundFloat(location.x);
//            NSUInteger roundedY = RoundFloat(location.y);
//
//            if ((NSUInteger)location.x >= [self.pcxFile.pcxContent.pallete count]) {
//                return;
//            }
//            
//#warning need implement logic for get components from editedColor (gray scale or RGB)
//            
//            NSMutableArray *mutArray = self.pcxFile.pcxContent.pallete[roundedY];
//            for (int index = 0; index < [mutArray count]; index ++) {
//                NSMutableArray *array = mutArray[index];
//                NSUInteger valueForReplace = [self blackColorIndex];
//                [array replaceObjectAtIndex:roundedX withObject:[NSNumber numberWithInteger:valueForReplace]];
//            }
//            [self setNeedsDisplay];
//        }
//    }
}

- (NSUInteger)blackColorIndex
{
    static NSUInteger colorIndex = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat red = 255;
        CGFloat green = 255;
        CGFloat blue = 255;
        for (int i = 0; i < self.pcxFile.pcxContent.colorPallete.count; i+=3) {
            CGFloat currentRed = [self.pcxFile.pcxContent.colorPallete[i] floatValue];
            CGFloat currentGreen = [self.pcxFile.pcxContent.colorPallete[i + 1] floatValue];
            CGFloat currentBlue = [self.pcxFile.pcxContent.colorPallete[i + 2] floatValue];
            if (currentRed < red && currentGreen < green && currentBlue < blue) {
                red = currentRed;
                green = currentGreen;
                blue = currentBlue;
                colorIndex = i;
            }
        }
    });
    return colorIndex;
}

- (NSUInteger)whiteColorIndex
{
    static NSUInteger colorIndex = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat red = 0;
        CGFloat green = 0;
        CGFloat blue = 0;
        for (int i = 0; i < self.pcxFile.pcxContent.colorPallete.count; i+=3) {
            CGFloat currentRed = [self.pcxFile.pcxContent.colorPallete[i] floatValue];
            CGFloat currentGreen = [self.pcxFile.pcxContent.colorPallete[i + 1] floatValue];
            CGFloat currentBlue = [self.pcxFile.pcxContent.colorPallete[i + 2] floatValue];
            if (currentRed > red && currentGreen > green && currentBlue > blue) {
                red = currentRed;
                green = currentGreen;
                blue = currentBlue;
                colorIndex = i;
            }
        }
    });
    return colorIndex;
}

#pragma mark -
#pragma mark Help Methods

- (void)convertPixelsToBlackWithMaxBlackValue:(NSUInteger)maxBlackValue
{
    NSUInteger blackColorIndex = [self blackColorIndex];
    NSUInteger whiteColorIndex = [self whiteColorIndex];
    for (int i = 0; i < self.pcxFile.pcxContent.pallete.count; i++) {
        NSMutableArray *linePallete = self.pcxFile.pcxContent.pallete[i];
        NSUInteger count = [linePallete[0] isKindOfClass:[NSArray class]] ? [linePallete[0] count] : [linePallete count];
        for (int j = 0; j < count; j++) {
            NSUInteger value = [linePallete[0][j] unsignedIntegerValue];
            if (value != blackColorIndex && value >= maxBlackValue) {
                value = blackColorIndex;
            } else {
                value = whiteColorIndex;
            }
            
            [linePallete[0] replaceObjectAtIndex:j withObject:[NSNumber numberWithInteger:value / 3]];
        }
    }
    [self setNeedsDisplay];
}

- (UIColor *)colorFromLinePallete:(NSArray *)linePallete withIndex:(NSUInteger)index alpha:(CGFloat)alpha
{
    UIColor *color = nil;
    NSUInteger linePalleteCount = [linePallete count];
    if (self.pcxFile.pcxHeader.palleteInfo == 1 && self.pcxFile.pcxHeader.bitsPerPixel == 8 && self.pcxFile.pcxContent.colorPallete) {
#ifdef DEBUG_MOD
        NSLog(@"color as index");
#endif
        if (index >= self.pcxFile.pcxContent.colorPallete.count) {
            return color;
        }
        
        NSArray *colorIndexs = [linePallete lastObject];
        
        if ([colorIndexs[index] integerValue] == 777) {
            return [UIColor redColor];
        }
        
        if ([colorIndexs[index] integerValue] == 776) {
            return [UIColor greenColor];
        }
        
        if ([colorIndexs[index] integerValue] == 775) {
            return [UIColor blueColor];
        }
        
        if ([colorIndexs[index] integerValue] == 774 || [colorIndexs[index] integerValue] == 778) {
            return [UIColor orangeColor];
        }
        
        if ([colorIndexs[index] integerValue] > 255) {
            NSUInteger indexColor = [colorIndexs[index] integerValue] - 255;
            CGFloat value = 0.1;
            while (indexColor > 0) {
                value += 0.15;
                indexColor --;
            }
            
            return [UIColor colorWithRed:value
                                   green:1.0f
                                    blue:1.0f
                                   alpha:1.0f];
        }
        
        NSUInteger colorIndex = [colorIndexs[index] floatValue] * 3;
        if (colorIndex >= self.pcxFile.pcxContent.colorPallete.count) {
            colorIndex /= 3;
        }
        
        CGFloat red = [self.pcxFile.pcxContent.colorPallete[colorIndex] floatValue];
        CGFloat green = [self.pcxFile.pcxContent.colorPallete[colorIndex + 1] floatValue];
        CGFloat blue = [self.pcxFile.pcxContent.colorPallete[colorIndex+ 2] floatValue];
        return RGBA(red, green, blue, alpha);
    }
    
    switch (linePalleteCount) {
        case 1: {
            CGFloat grayScaleValue = [linePallete[0][index] floatValue];
            if ([self.pcxFile.pcxContent.colorPallete count]) {
                grayScaleValue = [self.pcxFile.pcxContent.colorPallete[((int)grayScaleValue) * 3] integerValue];
            }
#ifdef DEBUG_MOD
            NSLog(@"gray scale = %f", grayScaleValue);
#endif
            color = WA(grayScaleValue, alpha);
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
        case 4: {
            CGFloat red = [linePallete[0][index] floatValue];
            CGFloat green = [linePallete[1][index] floatValue];
            CGFloat blue = [linePallete[2][index] floatValue];
            CGFloat alphaValue = [linePallete[3][index] floatValue];
            
            color = [UIColor colorWithRed:red / 255.0f
                                    green:green / 255.0f
                                     blue:blue / 255.0f
                                    alpha:alphaValue / 255.0f];
        }
            break;
        default:
            NSAssert(nil, @"not supported this channel bits count");
            break;
    }
    return color;
}

@end
