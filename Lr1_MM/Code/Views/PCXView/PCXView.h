//
//  PCXView.h
//  Lr1_MM
//
//  Created by Max Kuznetsov on 13.10.13.
//  Copyright (c) 2013 111Minutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawLayerView.h"
#import "PCXAnalizer.h"

@class PCXFile;

@interface PCXView : UIView

@property (nonatomic, strong) UIColor *editedColor;
@property (nonatomic, strong) DrawLayerView *drawLayerView;
@property (nonatomic, strong) PCXFile *pcxFile;
@property (nonatomic, strong) PCXAnalizer *pcxAnalizer;

@property (nonatomic, strong) void(^touchBlock)(UITouch *touch);

- (id)initWithPCXFile:(PCXFile *)pcxFile;

- (void)convertPixelsToBlackWithMaxBlackValue:(NSUInteger)maxBlackValue;
- (NSUInteger)whiteColorIndex;
- (NSUInteger)blackColorIndex;

- (UIColor *)colorFromLinePallete:(NSArray *)linePallete withIndex:(NSUInteger)index alpha:(CGFloat)alpha;

@end
