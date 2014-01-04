//
//  FirstPass.h
//  Lr1_MM
//
//  Created by Max Kuznetsov on 02.01.14.
//  Copyright (c) 2014 111Minutes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCXContent.h"

@interface FirstPass : NSObject

+ (void)thinningDevider:(CGRect)devide
             pcxContent:(PCXContent *)pcxContent
             blackIndex:(NSUInteger)blackIndex
             whiteIndex:(NSUInteger)whiteIndex;

@end
