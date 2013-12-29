//
//  BaseAperture.h
//  Lr1_MM
//
//  Created by Max Kuznetsov on 29.12.13.
//  Copyright (c) 2013 111Minutes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseAperture : NSObject

@property (nonatomic, assign) NSUInteger whiteIndex;
@property (nonatomic, assign) NSUInteger blackIndex;

- (BOOL)isPixelEqualToAperture:(NSMutableArray *)matr rowsIndex:(NSUInteger)rowsIndex rowIndex:(NSUInteger)rowIndex;

@end
