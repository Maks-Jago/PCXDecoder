//
//  BlackPixelsCalculator.h
//  Lr1_MM
//
//  Created by Max Kuznetsov on 11.01.14.
//  Copyright (c) 2014 111Minutes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlackPixelsCalculator : NSObject

+ (NSUInteger)calculateBlackPixelsForPoint:(CGPoint)point
                                withDevide:(CGRect)devide
                                   pallete:(NSMutableArray *)pallete
                                whiteIndex:(NSUInteger)whiteIndex
                                blackIndex:(NSUInteger)blackIndex;

@end
