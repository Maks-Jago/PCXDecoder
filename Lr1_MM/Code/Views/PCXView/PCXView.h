//
//  PCXView.h
//  Lr1_MM
//
//  Created by Max Kuznetsov on 13.10.13.
//  Copyright (c) 2013 111Minutes. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PCXFile;

@interface PCXView : UIView

- (id)initWithPCXFile:(PCXFile *)pcxFile;

@end
