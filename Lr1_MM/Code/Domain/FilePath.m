//
//  FilePath.m
//  Lr1_MM
//
//  Created by Max Kuznetsov on 19.01.14.
//  Copyright (c) 2014 111Minutes. All rights reserved.
//

#import "FilePath.h"

@interface FilePath ()

@property (nonatomic, readwrite, strong) NSString *path;

@end

@implementation FilePath

+ (FilePath *)shared
{
    static FilePath *filePath = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        filePath = [FilePath new];
    });
    return filePath;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.path = kFilePath;
    }
    return self;
}

- (void)changeFilePath
{
    if ([self.path isEqualToString:kSampleText3]) {
        self.path = kTest3;
    } else if ([self.path isEqualToString:kTest3]) {
        self.path = kTest4;
    } else {
        self.path = kSampleText3;
    }
}


@end
