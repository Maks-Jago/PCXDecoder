//
//  PCXFile.h
//  Lr1_MM
//
//  Created by Max Kuznetsov on 15.10.13.
//  Copyright (c) 2013 111Minutes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCXHeader.h"
#import "PCXContent.h"

@interface PCXFile : NSObject

@property (nonatomic, readonly, strong) PCXHeader *pcxHeader;
@property (nonatomic, readonly, strong) PCXContent *pcxContent;

- (id)initWithData:(NSData *)data;

- (void)saveFileWithName:(NSString *)newFileName;

@end
