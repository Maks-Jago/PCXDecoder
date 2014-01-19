//
//  TrainDividersViewController.h
//  Lr1_MM
//
//  Created by Max Kuznetsov on 12.01.14.
//  Copyright (c) 2014 111Minutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCXContent.h"
#import "PCXAnalizer.h"
#import "PCXFile.h"

@interface TrainDividersViewController : UIViewController

- (id)initWithPCXContent:(PCXContent *)content pcxAnalizer:(PCXAnalizer *)analizer pcxFile:(PCXFile *)pcxFile;

@end
