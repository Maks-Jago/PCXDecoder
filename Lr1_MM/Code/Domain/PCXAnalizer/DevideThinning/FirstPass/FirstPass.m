//
//  FirstPass.m
//  Lr1_MM
//
//  Created by Max Kuznetsov on 02.01.14.
//  Copyright (c) 2014 111Minutes. All rights reserved.
//

#import "FirstPass.h"

@implementation FirstPass

/*
 p3 p2 p1
 p4 ss p0
 p5 p6 p7
 */

+ (void)thinningDevider:(CGRect)devide
             pcxContent:(PCXContent *)pcxContent
             blackIndex:(NSUInteger)blackIndex 
             whiteIndex:(NSUInteger)whiteIndex
{
    for (int i = devide.origin.y; i < devide.size.height; i++) {
        for (int j = devide.origin.x; j < devide.size.width; j++) {
            NSNumber *value = pcxContent.pallete[i][0][j];
            if ([value unsignedIntegerValue] == blackIndex) {
                NSUInteger p1 = whiteIndex;
                NSUInteger p2 = blackIndex;
                NSUInteger p3 = whiteIndex;
                if (i - 1 >= 0) {
                    p2 = [pcxContent.pallete[i - 1][0][j] unsignedIntegerValue];
                    
                    if (j + 1 < [pcxContent.pallete[i - 1][0] count]) {
                        p1 = [pcxContent.pallete[i - 1][0][j + 1] unsignedIntegerValue];
                    }
                    
                    if (j - 1 >= 0) {
                        p3 = [pcxContent.pallete[i - 1][0][j - 1] unsignedIntegerValue];
                    }
                }
                
                NSUInteger p6 = whiteIndex;
                if (i + 1 < pcxContent.pallete.count) {
                    p6 = [pcxContent.pallete[i + 1][0][j] unsignedIntegerValue];
                }
                
                NSUInteger p4 = blackIndex;
                if (j - 1 >= 0) {
                    p4 = [pcxContent.pallete[i][0][j - 1] unsignedIntegerValue];
                }
                
                NSUInteger p0 = blackIndex;
                if (j + 1 < [pcxContent.pallete[i - 1][0] count]) {
                    p0 = [pcxContent.pallete[i][0][j + 1] unsignedIntegerValue];
                }
                
                /*
                 X = not p2 and p6 (пиксель является граничной точкой) and X (пиксель принадлежит объекту)
                 and ( not p1 and p4 or not p3 and p0 or p0 and p4) (пиксель не является элементом дуги и точкой конца).
                 */
                if (p2 != blackIndex && p6 == blackIndex &&
                    ((p1 != blackIndex && p4 == blackIndex) || (p3 != blackIndex && p0 == blackIndex) ||
                     (p0 == blackIndex && p4 == blackIndex))) {
                        NSUInteger value = whiteIndex;
#if DEVIDE_THINNING_DEBUG
                        value = 775;
#endif
                        [pcxContent.pallete[i][0] replaceObjectAtIndex:j withObject:[NSNumber numberWithUnsignedInteger:value]];
                }
            }
        }
    }

}

@end


