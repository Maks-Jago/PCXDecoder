//
//  Mensuration.h
//  Lr1_MM
//
//  Created by Max Kuznetsov on 18.01.14.
//  Copyright (c) 2014 111Minutes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Mensuration : NSObject

@property (nonatomic, copy) NSArray *vertical;
@property (nonatomic, copy) NSArray *horizontal;

@property (nonatomic, assign) CGRect divide;
@property (nonatomic, strong) NSString *letter;
@property (nonatomic, strong) NSArray *pallete;
@property (nonatomic, assign) NSUInteger blackIndex;
@property (nonatomic, strong) UIImage *image;

+ (Mensuration *)mensurationFromDivide:(CGRect)divide
                           withPallete:(NSArray *)pallete
                                letter:(NSString *)letter 
                            blackIndex:(NSUInteger)blackIndex;

- (BOOL)isEqual:(Mensuration *)object;

@end
