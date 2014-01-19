//
//  Recognizer.m
//  Lr1_MM
//
//  Created by Max Kuznetsov on 18.01.14.
//  Copyright (c) 2014 111Minutes. All rights reserved.
//

#import "Recognizer.h"

@interface Recognizer ()

@property (nonatomic, strong) NSMutableDictionary *mensurations;

@end

@implementation Recognizer

+ (Recognizer *)shared
{
    static Recognizer *recognizer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        recognizer = [Recognizer new];
    });
    return recognizer;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.mensurations = [NSMutableDictionary new];
    }
    return self;
}

- (void)addMensurationForDivide:(CGRect)divide letter:(NSString *)letter
{
    Mensuration *mensuration = [Mensuration mensurationFromDivide:divide withPallete:self.pallete letter:letter blackIndex:self.blackIndex];
    NSMutableArray *arr = [self.mensurations valueForKey:letter];
    if (!arr) {
        arr = [NSMutableArray new];
    }
    
    [arr addObject:mensuration];
    [self.mensurations setValue:arr
                         forKey:letter];
}

- (Mensuration *)mensurationForDivide:(CGRect)divide
{
    NSArray *array = self.mensurations.allValues;
    for (Mensuration *mensuration in array) {
        if (CGRectContainsRect(mensuration.divide, divide)) {
            return mensuration;
        }
    }
    return nil;
}

- (Mensuration *)recognizeDivide:(CGRect)divide
{
    Mensuration *divideMensuration = [Mensuration mensurationFromDivide:divide
                                                            withPallete:self.pallete
                                                                 letter:@""
                                                             blackIndex:self.blackIndex];

    for (NSString *mensurationsKey in self.mensurations.allKeys) {
        NSArray *arr = [self.mensurations valueForKey:mensurationsKey];
        for (Mensuration *mensuration in arr) {
            if ([mensuration isEqual:divideMensuration]) {
                return mensuration;
            }
        }
    }
    return nil;
}


@end
