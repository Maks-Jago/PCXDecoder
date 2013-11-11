//
//  PCXFile.m
//  Lr1_MM
//
//  Created by Max Kuznetsov on 15.10.13.
//  Copyright (c) 2013 111Minutes. All rights reserved.
//

#import "PCXFile.h"

@interface PCXFile ()

@property (nonatomic, readwrite, strong) PCXHeader *pcxHeader;
@property (nonatomic, readwrite, strong) PCXContent *pcxContent;

@property (nonatomic, strong) NSData *data;

@end

@implementation PCXFile

- (id)initWithData:(NSData *)data
{
    self = [super init];
    if (self) {
        self.data = data;
        [self decodeData];
    }
    return self;
}

- (void)decodeData
{
    NSParameterAssert(self.data);
    Byte *bytes = (Byte *)[self.data bytes];
    NSUInteger length = [self.data length];
 
    Byte *headerBytes = malloc(kHeaderSize);
    memcpy(headerBytes, bytes, kHeaderSize);
    
    self.pcxHeader = [[PCXHeader alloc] initWithBytes:headerBytes];    
    self.pcxContent = [[PCXContent alloc] initWithBytes:bytes length:length pcxHeader:self.pcxHeader];
    
    free(headerBytes);
}

- (void)saveFileByPath:(NSString *)filePath
{
    NSArray *encodedContent = [self.pcxContent encode];
    Byte *dataToSave = malloc(kHeaderSize * [encodedContent count]);
    memcpy(dataToSave, [self.data bytes], kHeaderSize);
    
    for (int i = 0; i < [encodedContent count]; i++) {
        dataToSave[i + kHeaderSize] = [encodedContent[i] integerValue];
    }
    
    NSData *contentData = [NSData dataWithBytes:dataToSave length:kHeaderSize + [encodedContent count]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:contentData attributes:nil];
}

@end
