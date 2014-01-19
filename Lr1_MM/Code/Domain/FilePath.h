//
//  FilePath.h
//  Lr1_MM
//
//  Created by Max Kuznetsov on 19.01.14.
//  Copyright (c) 2014 111Minutes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilePath : NSObject

@property (nonatomic, readonly) NSString *path;

+ (FilePath *)shared;

- (void)changeFilePath;

@end
