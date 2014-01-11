//
//  OnePixelEraser.h
//  Lr1_MM
//
//  Created by Max Kuznetsov on 11.01.14.
//  Copyright (c) 2014 111Minutes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OnePixelEraser : NSObject

+ (void)eraseOnePixel8x8WithDevide:(CGRect)devide
                           pallete:(NSMutableArray *)pallete
                        blackIndex:(NSUInteger)blackIndex
                        whiteIndex:(NSUInteger)whiteIndex;

@end
