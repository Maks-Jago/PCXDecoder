//
//  DevideThinning.h
//  Lr1_MM
//
//  Created by Max Kuznetsov on 02.01.14.
//  Copyright (c) 2014 111Minutes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCXContent.h"

@interface DevideThinning : NSObject

@property (nonatomic, assign) NSUInteger whiteIndex;
@property (nonatomic, assign) NSUInteger blackIndex;

- (id)initWithPCXContent:(PCXContent *)pcxContent;

- (void)createPalleteCopy;
- (void)thinningDevide:(CGRect)devide;

@end
