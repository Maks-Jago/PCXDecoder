//
//  NSArray+LogMatr.m
//  Lr1_MM
//
//  Created by Max Kuznetsov on 28.12.13.
//  Copyright (c) 2013 111Minutes. All rights reserved.
//

#import "NSArray+LogMatr.h"

@implementation NSArray (LogMatr)

- (NSString *)logMatr
{
    NSMutableString *string = nil;
    if ([[self lastObject] isKindOfClass:[NSArray class]]) {
        string = [[NSMutableString alloc] init];
        for (int i = 0; i < self.count; i++) {
            NSArray *row = self[i][0];
            for (int j = 0; j < row.count; j++) {
                [string appendFormat:@"%d ", [row[j] integerValue]];
            }
            [string appendString:@"\n"];
        }
    }
    return string;
}

@end
