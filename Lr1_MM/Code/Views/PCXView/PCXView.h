//
//  PCXView.h
//  Lr1_MM
//
//  Created by Max Kuznetsov on 13.10.13.
//  Copyright (c) 2013 111Minutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawLayerView.h"

@class PCXFile;

@interface PCXView : UIView

@property (nonatomic, strong) UIColor *editedColor;
@property (nonatomic, strong) DrawLayerView *drawLayerView;
@property (nonatomic, strong) PCXFile *pcxFile;

- (id)initWithPCXFile:(PCXFile *)pcxFile;

- (void)convertPixelsToBlackWithMaxBlackValue:(NSUInteger)maxBlackValue;
- (NSUInteger)whiteColorIndex;
- (NSUInteger)blackColorIndex;

@end
