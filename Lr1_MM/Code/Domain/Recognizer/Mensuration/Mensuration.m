//
//  Mensuration.m
//  Lr1_MM
//
//  Created by Max Kuznetsov on 18.01.14.
//  Copyright (c) 2014 111Minutes. All rights reserved.
//

#import "Mensuration.h"

@implementation Mensuration

//- (void)encodeWithCoder:(NSCoder *)coder;
//{
//    [coder encodeObject:self.horizontal forKey:@"horizontal"];
//    [coder encodeCGRect:self.divide forKey:@"divide"];
//}
//
//- (id)initWithCoder:(NSCoder *)coder;
//{
//    self = [super init];
//    if (self != nil)
//    {
//        self.horizontal = [coder decodeObjectForKey:@"horizontal"];
//        self.divide = [coder decodeCGRectForKey:@"divide"];
//    }
//    return self;
//}

+ (Mensuration *)mensurationFromDivide:(CGRect)divide
                           withPallete:(NSArray *)pallete
                                letter:(NSString *)letter
                            blackIndex:(NSUInteger)blackIndex
{
    Mensuration *mensuration = [Mensuration new];
    mensuration.letter = letter;
    mensuration.divide = divide;
    mensuration.pallete = pallete;
    mensuration.blackIndex = blackIndex;
    
    [self findMensurationsFromDivide:divide mensuration:mensuration pallete:pallete blackIndex:blackIndex];
    return mensuration;
}

+ (void)findMensurationsFromDivide:(CGRect)divide
                       mensuration:(Mensuration *)mensuration 
                           pallete:(NSArray *)pallete 
                        blackIndex:(NSUInteger)blackIndex
{
    int rowCount = divide.size.width / 3;
    int cellCount = divide.size.height / 3;    
    NSMutableArray *horizontalSum = [NSMutableArray new];
    
    for (int i = 0; i < rowCount; i++) {
        for (int j = 0; j < cellCount; j++) {
            NSUInteger sum = 0;
            
            for (int rowIndex = divide.origin.y + (3 * i); rowIndex < divide.origin.y + 3 * (i + 1); rowIndex ++) {
                for (int cellIndex = divide.origin.x + (3 * j); cellIndex < (divide.origin.x + 3 * (j + 1)); cellIndex ++) {
                    if (rowIndex >= pallete.count || cellIndex >= [pallete[rowIndex][0] count]) {
                        NSLog(@"findMensurationsFromDivide error");
                        break;
                    }
                    
                    NSUInteger value = [pallete[rowIndex][0][cellIndex] unsignedIntegerValue];
                    if (value == blackIndex) {
                        sum++;
                    }
                }
            }
            [horizontalSum addObject:[NSNumber numberWithUnsignedInteger:sum]];
        }
    }
    
    mensuration.horizontal = horizontalSum;
}

- (BOOL)isEqual:(Mensuration *)object
{
    int selfCount = self.horizontal.count;
    int objectCount = object.horizontal.count;
    
    NSArray *horizontal = self.horizontal;
    
    NSUInteger count = selfCount;
    if (selfCount != objectCount) {
        NSLog(@"selfCount != objectCount");
        return NO;
    }
    
    for (int i = 0; i < count; i++) {
        NSUInteger selfValue = [horizontal[i] unsignedIntegerValue];
        NSUInteger objectValue = [object.horizontal[i] unsignedIntegerValue];
        NSUInteger percent = (selfValue + objectValue) * 0.7;
        CGFloat res = fabsf(selfValue - objectValue);
        if (res > percent && percent > 0) {
            return NO;
        }
    }
    
    return YES;
}

@end
