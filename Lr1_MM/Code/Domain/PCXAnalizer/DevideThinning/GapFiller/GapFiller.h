//
//  GapFiller.h
//  Lr1_MM
//
//  Created by Max Kuznetsov on 15.01.14.
//  Copyright (c) 2014 111Minutes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GapFiller : NSObject

- (id)initWithPallete:(NSMutableArray *)pallete
           whiteIndex:(NSUInteger)whiteIndex
           blackIndex:(NSUInteger)blackIndex;

- (void)fillGapsWithDivide:(CGRect)divide;

@end
