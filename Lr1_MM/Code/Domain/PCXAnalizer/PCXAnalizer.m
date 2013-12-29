//
//  PCXAnalizer.m
//  Lr1_MM
//
//  Created by Max Kuznetsov on 05.12.13.
//  Copyright (c) 2013 111Minutes. All rights reserved.
//

#import "PCXAnalizer.h"
#import "Devider.h"
#import "EmptiesFiller.h"
#import "FringeEraser.h"

@interface PCXAnalizer ()

@property (nonatomic, strong) PCXContent *pcxContent;
@property (nonatomic, strong) EmptiesFiller *emptiesFiller;
@property (nonatomic, strong) FringeEraser *fringeEraser;

@property (nonatomic, readwrite, strong) NSMutableArray *deviders;
@property (nonatomic, assign) NSUInteger blackIndex;
@property (nonatomic, assign) NSUInteger whiteIndex;

@end

@implementation PCXAnalizer

- (id)initWithPCXContent:(PCXContent *)content blackIndex:(NSUInteger)blackIndex whiteIndex:(NSUInteger)whiteIndex
{
    self = [super init];
    if (self) {
        self.pcxContent = content;
        self.emptiesFiller = [[EmptiesFiller alloc] initWithPCXContent:content];
        self.emptiesFiller.blackIndex = blackIndex;
        self.emptiesFiller.whiteIndex = whiteIndex;
        
        self.fringeEraser = [[FringeEraser alloc] initWithPCXContent:content];
        self.fringeEraser.whiteIndex = whiteIndex;
        self.fringeEraser.blackIndex = blackIndex;
    }
    return self;
}

- (void)finSimbolDeviders
{
    self.deviders = [NSMutableArray new];
    [self findDeviders:CGPointZero lastFoundDevider:nil detectProcces:NO];
}

- (void)fillEmpties
{
    [self.emptiesFiller fillEmpties];
}

- (void)eraseFringe
{
    [self.fringeEraser eraseFringe];
}

#pragma mark -
#pragma mark Rects

- (NSArray *)simbolDeviders
{
    return @[[NSValue valueWithCGRect:CGRectMake(10, 10, 100, 20)], [NSValue valueWithCGRect:CGRectMake(110, 110, 50, 70)]];
}

- (void)findDeviders:(CGPoint)currentLocation lastFoundDevider:(Devider *)devider detectProcces:(BOOL)detectProcces
{
    if (!detectProcces) {
        NSNumber *value = self.pcxContent.pallete[(NSInteger)currentLocation.y][(NSInteger)currentLocation.x];
    } else {
        
    }
}

@end



