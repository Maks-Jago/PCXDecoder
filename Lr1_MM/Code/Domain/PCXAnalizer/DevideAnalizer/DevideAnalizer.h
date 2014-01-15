//
//  DevideAnalizer.h
//  Lr1_MM
//
//  Created by Max Kuznetsov on 30.12.13.
//  Copyright (c) 2013 111Minutes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCXContent.h"

@interface DevideAnalizer : NSObject

@property (nonatomic, assign) NSUInteger whiteIndex;
@property (nonatomic, assign) NSUInteger blackIndex;

- (id)initWithPCXContent:(PCXContent *)pcxContent;

- (NSArray *)devide;
- (NSArray *)getCurrentDevides;

- (void)setCurrentDevides:(NSArray *)divides;

@end
