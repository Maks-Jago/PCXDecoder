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

#import <InfColorPickerController.h>

@interface RootViewController () <UIScrollViewDelegate, InfColorPickerControllerDelegate>

@property (nonatomic, strong) PCXView *pcxView;
@property (nonatomic, strong) PCXFile *pcxFile;

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation RootViewController

#pragma mark -
#pragma mark View Managment

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"savedPcxFile13" ofType:@"pcx"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
    self.pcxFile = [[PCXFile alloc] initWithData:data];
    
    [self setupScrollView];
    [self setupButtons];
}

#pragma mark -
#pragma mark Configurations

- (void)setupButtons
{
    [self setupSaveButton];
    [self setupSelectColorButton];
}

- (void)setupSelectColorButton
{
    UIButton *selectColorButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    UIImage *selectColorButtonImage = [UIImage imageNamed:@"selectColor"];
    
    [selectColorButton setImage:selectColorButtonImage forState:(UIControlStateNormal)];
    selectColorButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    selectColorButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width + 73,
                                         120,
                                         selectColorButtonImage.size.width - 33,
                                         selectColorButtonImage.size.height - 5);
    selectColorButton.backgroundColor = [UIColor lightGrayColor];
    [selectColorButton setTitle:@"Save" forState:(UIControlStateNormal)];
    [selectColorButton addTarget:self action:@selector(selectColorButtonTapped) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:selectColorButton];
}

- (void)setupSaveButton
{
    UIButton *saveButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    UIImage *saveButtonImage = [UIImage imageNamed:@"saveFile"];
    
    [saveButton setImage:saveButtonImage forState:(UIControlStateNormal)];
    saveButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    saveButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width + 73,
                                  50, saveButtonImage.size.width - 60,
                                  saveButtonImage.size.height - 5);
    saveButton.backgroundColor = [UIColor lightGrayColor];
    [saveButton setTitle:@"Save" forState:(UIControlStateNormal)];
    [saveButton addTarget:self action:@selector(saveButtonTapped) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:saveButton];
}

- (void)setupPCXView
{
    self.pcxView = [[PCXView alloc] initWithPCXFile:self.pcxFile];
    
    CGRect frame = self.pcxView.frame;
    frame.origin = CGPointMake(self.view.frame.size.width / 2 - self.pcxFile.pcxHeader.imageSize.width / 2,
                               self.view.frame.size.height / 2 - self.pcxFile.pcxHeader.imageSize.height / 2);
    frame.size = self.pcxFile.pcxHeader.imageSize;
    self.pcxView.frame = frame;
}

- (void)setupScrollView
{
    [self setupPCXView];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 200, self.view.frame.size.height - 20)];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.scrollView.showsVerticalScrollIndicator = self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor redColor];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.delegate = self;
    
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 1000.0;
    self.scrollView.zoomScale = 10;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 2, self.scrollView.frame.size.height * 2);
    [self.scrollView addSubview:self.pcxView];
    
    [self.view addSubview:self.scrollView];
    [self.pcxView setNeedsDisplay];
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.pcxView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    scrollView.contentSize = CGSizeMake(4000 * scale, 4000 *scale);
    self.pcxView.tag = 0;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    self.pcxView.tag = 1;
}

#pragma mark -
#pragma mark Actions

- (void)saveButtonTapped
{
    static NSUInteger fileIndex = 1;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSMutableString *pathForSave = [NSMutableString stringWithString:[paths lastObject]];
    [pathForSave appendFormat:@"//savedPcxFile%d.pcx", fileIndex++];
    [self.pcxFile saveFileByPath:pathForSave];
}

- (void)selectColorButtonTapped
{
    InfColorPickerController *colorPickerController = [InfColorPickerController colorPickerViewController];
    colorPickerController.sourceColor = [UIColor blackColor];
    colorPickerController.delegate = self;
    [colorPickerController presentModallyOverViewController:self];
}

- (void)colorPickerControllerDidFinish:(InfColorPickerController*)controller
{
    NSLog(@"colorPickerControllerDidFinish");
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
