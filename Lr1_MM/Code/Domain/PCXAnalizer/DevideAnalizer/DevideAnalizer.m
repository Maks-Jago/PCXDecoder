//
//  DevideAnalizer.m
//  Lr1_MM
//
//  Created by Max Kuznetsov on 30.12.13.
//  Copyright (c) 2013 111Minutes. All rights reserved.
//

#import "DevideAnalizer.h"

static NSUInteger const kNotAnalizeValue = 9999;

@interface DevideAnalizer ()

@property (nonatomic, strong) PCXContent *pcxContent;
@property (nonatomic, strong) NSMutableArray *palleteCopy;
@property (nonatomic, strong) NSArray *currentDevides;

@end

@implementation DevideAnalizer

- (id)initWithPCXContent:(PCXContent *)pcxContent
{
    self = [super init];
    if (self) {
        self.pcxContent = pcxContent;
    }
    return self;
}

- (NSArray *)getCurrentDevides
{
    if (!self.currentDevides) {
        self.currentDevides = [self devide];
    }
    return self.currentDevides;
}

- (NSArray *)devide
{
    [self createPalleteCopy];
    
    NSMutableArray *deviders = [NSMutableArray new];
    BOOL needContinue = NO;
    int count = 0;
    CGPoint location = CGPointZero;
    do {
        needContinue = NO;
        [self findDeviders:location
             detectProcces:NO
                  deviders:deviders];

        if (deviders.count != count) {
            needContinue = YES;
            location = [[deviders lastObject] CGRectValue].origin;
            location.x += [[deviders lastObject] CGRectValue].size.width;
            count = deviders.count;
        }
    } while (needContinue);
    self.currentDevides = (NSArray *)deviders;
    return deviders;
}

- (void)createPalleteCopy
{
    self.palleteCopy = [[NSMutableArray alloc] init];
    for (NSArray *row in self.pcxContent.pallete) {
        NSArray *cell = row[0];
        NSMutableArray *newCell = [NSMutableArray new];
        for (NSNumber *value in cell) {
            [newCell addObject:[NSNumber numberWithUnsignedInteger:[value unsignedIntegerValue]]];
        }
        [self.palleteCopy addObject:@[newCell]];
    }
}

- (void)setWhiteIndex:(NSUInteger)whiteIndex
{
    _whiteIndex = whiteIndex / 3;
}

- (void)setBlackIndex:(NSUInteger)blackIndex
{
    _blackIndex = blackIndex / 3;
}

#pragma mark -
#pragma mark Rects

- (void)findDeviders:(CGPoint)currentLocation
       detectProcces:(BOOL)detectProcces
            deviders:(NSMutableArray *)deviders
{
    if (currentLocation.y >= self.palleteCopy.count) {
        NSLog(@"currentLocation.y >= self.palleteCopy.count");
        return;
    }
    
    if (!detectProcces) {
        NSArray *row = self.palleteCopy[(NSInteger)currentLocation.y];
        NSArray *cell = row[0];

        if (currentLocation.x >= [cell count]) {
            currentLocation.x = 0;
            currentLocation.y += 1;
            
            if (currentLocation.y >= self.palleteCopy.count) {
                return;
            }
        }

        NSUInteger value = [cell[(NSInteger)currentLocation.x] unsignedIntegerValue];
        if (value != self.blackIndex || value == kNotAnalizeValue) {
            [self findDeviders:CGPointMake(currentLocation.x + 1, currentLocation.y)
                 detectProcces:NO
                      deviders:deviders];
            
        } else if (value == self.blackIndex) {
            [self findDeviders:currentLocation
                 detectProcces:YES
                      deviders:deviders];
        }
    } else {
        [deviders addObject:[NSValue valueWithCGRect:CGRectMake(currentLocation.x, currentLocation.y, 0, 0)]];
        [self funcDetectProccessWithCurrentLocation:currentLocation
                                           deviders:deviders];
        
//        if (deviders.count >= 50) {
//            NSLog(@"");
//        }
        currentLocation.x += 1;

        return;
//        [self findDeviders:currentLocation
//             detectProcces:NO
//                  deviders:deviders];
    }
}

- (void)funcDetectProccessWithCurrentLocation:(CGPoint)currentLocation
                                     deviders:(NSMutableArray *)deviders
{
    CGRect deviderRect = [[deviders lastObject] CGRectValue];
    if (currentLocation.x < 0 || currentLocation.y < 0) {
        return;
    }
    
    if (currentLocation.y >= self.palleteCopy.count || currentLocation.x >= [self.palleteCopy[(NSInteger)currentLocation.y][0] count]) {
        return;
    }
    
//    if (currentLocation.x == 19 && currentLocation.y == 196) {
//        NSLog(@"");
//    }
    
    NSUInteger value = [self.palleteCopy[(NSInteger)currentLocation.y][0][(NSInteger)currentLocation.x] unsignedIntegerValue];
    if (value == self.whiteIndex || value == kNotAnalizeValue) {
        CGFloat width = currentLocation.x - deviderRect.origin.x;
        CGFloat height = currentLocation.y - deviderRect.origin.y;
        deviderRect = [self maxFromFirstRect:deviderRect secondRect:CGRectMake(currentLocation.x, currentLocation.y, width, height)];
        
        if (deviders.count) {
            CGRect lastDevider = [[deviders lastObject] CGRectValue];
            deviderRect = [self maxFromFirstRect:deviderRect secondRect:lastDevider];
            [deviders removeLastObject];
        }
        
        [deviders addObject:[NSValue valueWithCGRect:deviderRect]];
        [self.palleteCopy[(NSInteger)currentLocation.y][0] replaceObjectAtIndex:(NSUInteger)currentLocation.x
                                                                     withObject:[NSNumber numberWithUnsignedInteger:kNotAnalizeValue]];
        return;
    }
    
    [self.palleteCopy[(NSInteger)currentLocation.y][0] replaceObjectAtIndex:(NSUInteger)currentLocation.x
                                                                 withObject:[NSNumber numberWithUnsignedInteger:kNotAnalizeValue]];

    //left
    [self funcDetectProccessWithCurrentLocation:CGPointMake(currentLocation.x - 1, currentLocation.y)
                                       deviders:deviders];

    //right
    [self funcDetectProccessWithCurrentLocation:CGPointMake(currentLocation.x + 1, currentLocation.y)
                                       deviders:deviders];
    
    //up
    [self funcDetectProccessWithCurrentLocation:CGPointMake(currentLocation.x, currentLocation.y - 1)
                                       deviders:deviders];
    
    //down
    [self funcDetectProccessWithCurrentLocation:CGPointMake(currentLocation.x, currentLocation.y + 1)
                                       deviders:deviders];
    
    //up - left
    [self funcDetectProccessWithCurrentLocation:CGPointMake(currentLocation.x - 1, currentLocation.y - 1)
                                       deviders:deviders];

    //up - right
    [self funcDetectProccessWithCurrentLocation:CGPointMake(currentLocation.x + 1, currentLocation.y - 1)
                                       deviders:deviders];

    //down - left
    [self funcDetectProccessWithCurrentLocation:CGPointMake(currentLocation.x - 1, currentLocation.y + 1)
                                       deviders:deviders];
    
    //down - right
    [self funcDetectProccessWithCurrentLocation:CGPointMake(currentLocation.x + 1, currentLocation.y + 1)
                                       deviders:deviders];
}


- (CGRect)maxFromFirstRect:(CGRect)firstRect secondRect:(CGRect)secondRect;
{
    CGRect result = firstRect;
    if (secondRect.size.width > result.size.width) {
        result.size.width = secondRect.size.width;
    }
    
    if (secondRect.size.height > result.size.height) {
        result.size.height = secondRect.size.height;
    }
    
    if (secondRect.origin.x < result.origin.x) {
        result.origin.x = secondRect.origin.x;
    }
    
    if (secondRect.origin.y < result.origin.y) {
        result.origin.y = secondRect.origin.y;
    }

    return result;
}

@end


