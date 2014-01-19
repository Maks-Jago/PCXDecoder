//
//  Recognizer.h
//  Lr1_MM
//
//  Created by Max Kuznetsov on 18.01.14.
//  Copyright (c) 2014 111Minutes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mensuration.h"

@interface Recognizer : NSObject

@property (nonatomic, strong) NSArray *pallete;
@property (nonatomic, assign) NSUInteger blackIndex;

+ (Recognizer *)shared;

- (void)addMensurationForDivide:(CGRect)divide letter:(NSString *)letter;
- (Mensuration *)mensurationForDivide:(CGRect)divide;
- (Mensuration *)recognizeDivide:(CGRect)divide;

@end
