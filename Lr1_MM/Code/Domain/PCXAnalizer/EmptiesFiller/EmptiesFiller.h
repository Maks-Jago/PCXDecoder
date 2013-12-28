//
//  EmptiesFiller.h
//  Lr1_MM
//
//  Created by Max Kuznetsov on 28.12.13.
//  Copyright (c) 2013 111Minutes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCXContent.h"

@interface EmptiesFiller : NSObject

@property (nonatomic, assign) NSUInteger whiteIndex;
@property (nonatomic, assign) NSUInteger blackIndex;

- (id)initWithPCXContent:(PCXContent *)pcxContent;
- (void)fillEmpties;

@end
