//
//  PCXContent.h
//  Lr1_MM
//
//  Created by Max Kuznetsov on 13.10.13.
//  Copyright (c) 2013 111Minutes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCXHeader.h"

@interface PCXContent : NSObject

@property (nonatomic, strong) NSMutableArray *pallete;
@property (nonatomic, strong) NSMutableArray *colorPallete;

- (id)initWithBytes:(Byte *)bytes length:(NSUInteger)length pcxHeader:(PCXHeader *)pcxHeader;

- (NSArray *)encode;

@end
