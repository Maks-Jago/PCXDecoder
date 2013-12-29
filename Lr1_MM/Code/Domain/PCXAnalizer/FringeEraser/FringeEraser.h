//
//  FringeEraser.h
//  Lr1_MM
//
//  Created by Max Kuznetsov on 29.12.13.
//  Copyright (c) 2013 111Minutes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCXContent.h"

#define FRINGE_ERASER_DEBUG

@interface FringeEraser : NSObject

@property (nonatomic, assign) NSUInteger whiteIndex;
@property (nonatomic, assign) NSUInteger blackIndex;

- (id)initWithPCXContent:(PCXContent *)pcxContent;

- (void)eraseFringe;

@end
