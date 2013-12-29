//
//  PCXAnalizer.h
//  Lr1_MM
//
//  Created by Max Kuznetsov on 05.12.13.
//  Copyright (c) 2013 111Minutes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCXContent.h"

@interface PCXAnalizer : NSObject

@property (nonatomic, readonly) NSArray *deviders;

- (id)initWithPCXContent:(PCXContent *)content blackIndex:(NSUInteger)blackIndex whiteIndex:(NSUInteger)whiteIndex;

- (void)fillEmpties;
- (void)eraseFringe;

@end
