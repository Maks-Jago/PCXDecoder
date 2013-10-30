//
//  RootViewController.m
//  Lr1_MM
//
//  Created by Max Kuznetsov on 13.10.13.
//  Copyright (c) 2013 111Minutes. All rights reserved.
//

#import "RootViewController.h"
#import "PCXView.h"
#import "PCXFile.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"10x10" ofType:@"pcx"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
    
    PCXFile *pcxFile = [[PCXFile alloc] initWithData:data];
    PCXView *pcxView = [[PCXView alloc] initWithPCXFile:pcxFile];
    
    CGRect frame = pcxView.frame;
    frame.origin = CGPointMake(10, 100);
    frame.size = pcxFile.pcxHeader.imageSize;
    pcxView.frame = frame;
    
    [self.view addSubview:pcxView];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [pcxView setNeedsDisplay];
}

@end
