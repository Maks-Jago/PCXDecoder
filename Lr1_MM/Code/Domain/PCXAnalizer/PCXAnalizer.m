//
//  PCXAnalizer.m
//  Lr1_MM
//
//  Created by Max Kuznetsov on 05.12.13.
//  Copyright (c) 2013 111Minutes. All rights reserved.
//

#import "PCXAnalizer.h"
#import "EmptiesFiller.h"
#import "FringeEraser.h"
#import "DevideAnalizer.h"
#import "DevideThinning.h"

@interface PCXAnalizer ()

@property (nonatomic, strong) PCXContent *pcxContent;
@property (nonatomic, strong) EmptiesFiller *emptiesFiller;
@property (nonatomic, strong) FringeEraser *fringeEraser;
@property (nonatomic, strong) DevideAnalizer *devideAnalizer;
@property (nonatomic, strong) DevideThinning *devideThinning;

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
        self.fringeEraser.useCopy = YES;
        
        self.devideAnalizer = [[DevideAnalizer alloc] initWithPCXContent:content];
        self.devideAnalizer.whiteIndex = whiteIndex;
        self.devideAnalizer.blackIndex = blackIndex;
        
        self.devideThinning = [[DevideThinning alloc] initWithPCXContent:content];
        self.devideThinning.whiteIndex = whiteIndex;
        self.devideThinning.blackIndex = blackIndex;
    }
    return self;
}

- (void)fillEmpties
{
    [self.emptiesFiller fillEmpties];
}

- (void)eraseFringe
{
    [self.fringeEraser eraseFringe];
}

- (NSArray *)devide
{
//    return [self.devideAnalizer devide];
    return [self.devideAnalizer getCurrentDevides];
}

- (void)setDivides:(NSArray *)divides
{
    [self.devideAnalizer setCurrentDevides:divides];
}

- (void)thinningDevides
{
    [self.devideThinning createPalleteCopy];
    
    NSArray *devides = [self.devideAnalizer getCurrentDevides];
    for (NSValue *devide in devides) {
        [self.devideThinning thinningDevide:[devide CGRectValue]];
    }
}

@end



