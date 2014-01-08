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
#import "PCXAnalizer.h"

#import <InfColorPickerController.h>

#define kOffsetX [UIScreen mainScreen].bounds.size.width + 73

@interface RootViewController () <UIScrollViewDelegate, InfColorPickerControllerDelegate>

@property (nonatomic, strong) PCXView *pcxView;
@property (nonatomic, strong) PCXFile *pcxFile;
@property (nonatomic, strong) PCXAnalizer *pcxAnalizer;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UISlider *slider;

@end

@implementation RootViewController

#pragma mark -
#pragma mark View Managment

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:kFilePath ofType:@"pcx"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
    self.pcxFile = [[PCXFile alloc] initWithData:data];
    
    [self setupScrollView];
    [self setupButtons];
//    [self setupSlider];
    [self setupDevideButton];
    [self setupThinningButton];
    
    self.pcxAnalizer = [[PCXAnalizer alloc] initWithPCXContent:self.pcxFile.pcxContent
                                                    blackIndex:[self.pcxView blackColorIndex]
                                                    whiteIndex:[self.pcxView whiteColorIndex]];
    [self resetButtonTapped];
}

#pragma mark -
#pragma mark Configurations

- (void)setupSlider
{
    self.slider = [[UISlider alloc] initWithFrame:CGRectMake(kOffsetX, 300, 170, 50)];
    self.slider.value = 0.9;
    [self.view addSubview:self.slider];
}

- (void)setupButtons
{
    [self setupResetButton];
    [self setupSaveButton];
    [self setupFillButton];
    [self setupEraseFringeButton];
//    [self setupSelectColorButton];
    [self setupConvertToBlackButton];
}

- (void)setupResetButton
{
    UIButton *resetButton = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    
    [resetButton setTitle:@"Reset" forState:(UIControlStateNormal)];
    [resetButton.titleLabel setFont:[UIFont systemFontOfSize:34]];
    [resetButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    
    resetButton.backgroundColor = [UIColor colorWithRed:49.0 / 255.0f green:78.0 / 255.0f blue:125.0f / 255.0f alpha:1.0f];
    resetButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    resetButton.frame = CGRectMake(kOffsetX, 10, 180, 50);
    [resetButton addTarget:self action:@selector(resetButtonTapped) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:resetButton];
}

- (void)setupConvertToBlackButton
{
    UIButton *toBlackButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    UIImage *toBlackButtonImage = [UIImage imageNamed:@"toBlack"];
    
    [toBlackButton setImage:toBlackButtonImage forState:(UIControlStateNormal)];
    toBlackButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    toBlackButton.frame = CGRectMake(kOffsetX,
                                     220,
                                     toBlackButtonImage.size.width - 73,
                                     toBlackButtonImage.size.height - 5);
    [toBlackButton addTarget:self action:@selector(toBlackButtonTapped) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:toBlackButton];
}

- (void)setupSelectColorButton
{
    UIButton *selectColorButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    UIImage *selectColorButtonImage = [UIImage imageNamed:@"selectColor"];
    
    [selectColorButton setImage:selectColorButtonImage forState:(UIControlStateNormal)];
    selectColorButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    selectColorButton.frame = CGRectMake(kOffsetX,
                                         120,
                                         selectColorButtonImage.size.width - 33,
                                         selectColorButtonImage.size.height - 5);
    selectColorButton.backgroundColor = [UIColor lightGrayColor];
    [selectColorButton addTarget:self action:@selector(selectColorButtonTapped) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:selectColorButton];
}

- (void)setupSaveButton
{
    UIButton *saveButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    UIImage *saveButtonImage = [UIImage imageNamed:@"saveFile"];
    
    [saveButton setImage:saveButtonImage forState:(UIControlStateNormal)];
    saveButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    saveButton.frame = CGRectMake(kOffsetX,
                                  65, saveButtonImage.size.width - 60,
                                  saveButtonImage.size.height - 5);
    saveButton.backgroundColor = [UIColor lightGrayColor];
    [saveButton addTarget:self action:@selector(saveButtonTapped) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:saveButton];
}

- (void)setupDevideButton
{
    UIButton *devideButton = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    
    [devideButton setTitle:@"Devide" forState:(UIControlStateNormal)];
    [devideButton.titleLabel setFont:[UIFont systemFontOfSize:34]];
    [devideButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    
    devideButton.backgroundColor = [UIColor colorWithRed:49.0 / 255.0f green:78.0 / 255.0f blue:125.0f / 255.0f alpha:1.0f];
    devideButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    devideButton.frame = CGRectMake(kOffsetX, 400, 180, 50);
    [devideButton addTarget:self action:@selector(devideButtonTapped) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:devideButton];
}

- (void)setupFillButton
{
    UIButton *fillButton = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    
    [fillButton setTitle:@"Fill empties" forState:(UIControlStateNormal)];
    [fillButton.titleLabel setFont:[UIFont systemFontOfSize:28]];
    [fillButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    
    fillButton.backgroundColor = [UIColor colorWithRed:49.0 / 255.0f green:78.0 / 255.0f blue:125.0f / 255.0f alpha:1.0f];
    fillButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    fillButton.frame = CGRectMake(kOffsetX, 455, 180, 50);
    [fillButton addTarget:self action:@selector(fillButtonTapped) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:fillButton];
}

- (void)setupEraseFringeButton
{
    UIButton *eraseFringeButton = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    
    [eraseFringeButton setTitle:@"Erase Fringe" forState:(UIControlStateNormal)];
    [eraseFringeButton.titleLabel setFont:[UIFont systemFontOfSize:28]];
    [eraseFringeButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    
    eraseFringeButton.backgroundColor = [UIColor colorWithRed:49.0 / 255.0f green:78.0 / 255.0f blue:125.0f / 255.0f alpha:1.0f];
    eraseFringeButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    eraseFringeButton.frame = CGRectMake(kOffsetX, 510, 180, 50);
    [eraseFringeButton addTarget:self action:@selector(eraseFringeButtonTapped) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:eraseFringeButton];
}

- (void)setupThinningButton
{
    UIButton *thinningButton = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    
    [thinningButton setTitle:@"Thinning" forState:(UIControlStateNormal)];
    [thinningButton.titleLabel setFont:[UIFont systemFontOfSize:28]];
    [thinningButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    
    thinningButton.backgroundColor = [UIColor colorWithRed:49.0 / 255.0f green:78.0 / 255.0f blue:125.0f / 255.0f alpha:1.0f];
    thinningButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    thinningButton.frame = CGRectMake(kOffsetX, 690, 180, 50);
    [thinningButton addTarget:self action:@selector(thinningButtonTapped) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:thinningButton];
}


- (void)setupPCXView
{
    self.pcxView = [[PCXView alloc] initWithPCXFile:self.pcxFile];
    self.pcxView.backgroundColor = [UIColor whiteColor];
    
    CGRect frame = self.pcxView.frame;
    frame.size = CGSizeMake(self.pcxFile.pcxHeader.imageSize.width + 1, self.pcxFile.pcxHeader.imageSize.height) ;
    self.pcxView.frame = frame;
    self.pcxView.center = CGPointMake(self.scrollView.frame.size.width / 2, self.scrollView.frame.size.height / 2);
}

- (void)setupScrollView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 200, self.view.frame.size.height - 20)];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.scrollView.showsVerticalScrollIndicator = self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor lightGrayColor];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.delegate = self;
    
    [self setupPCXView];
    self.scrollView.minimumZoomScale = self.scrollView.frame.size.width / self.pcxView.frame.size.width;
    self.scrollView.maximumZoomScale = 1000.0;
    self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
    self.scrollView.contentSize = self.pcxView.frame.size;
    
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
    self.pcxView.tag = 0;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    self.pcxView.frame = [self centeredFrameForScrollView:scrollView andUIView:self.pcxView];
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    self.pcxView.tag = 1;
}

- (CGRect)centeredFrameForScrollView:(UIScrollView *)scroll andUIView:(UIView *)rView
{
    CGSize boundsSize = scroll.bounds.size;
    CGRect frameToCenter = rView.frame;
    // center horizontally
    if (frameToCenter.size.width <= boundsSize.width) {
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    }

    // center vertically
    if (frameToCenter.size.height <= boundsSize.height) {
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    }
    return frameToCenter;
}

#pragma mark -
#pragma mark Actions

- (void)toBlackButtonTapped
{
//    [self.pcxView convertPixelsToBlackWithMaxBlackValue:self.slider.value * 255];
    [self.pcxView convertPixelsToBlackWithMaxBlackValue:0.3 * 255];
}

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

- (void)fillButtonTapped
{
    [self.pcxAnalizer fillEmpties];
    [self.pcxView setNeedsDisplay];
}

- (void)eraseFringeButtonTapped
{
    [self.pcxAnalizer eraseFringe];
    [self.pcxView setNeedsDisplay];
}

- (void)resetButtonTapped
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:kFilePath ofType:@"pcx"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
    self.pcxFile = [[PCXFile alloc] initWithData:data];
    
    self.pcxAnalizer = [[PCXAnalizer alloc] initWithPCXContent:self.pcxFile.pcxContent
                                                    blackIndex:[self.pcxView blackColorIndex]
                                                    whiteIndex:[self.pcxView whiteColorIndex]];

    self.pcxView.pcxFile = self.pcxFile;
    [self.pcxView.drawLayerView setRects:nil];
    [self.pcxView setNeedsDisplay];
}

- (void)devideButtonTapped
{
    if (self.pcxView.drawLayerView.rects.count) {
        [self.pcxView.drawLayerView setRects:nil];
    } else {
        NSArray *deviders = [self.pcxAnalizer devide];
        [self.pcxView.drawLayerView setRects:deviders];
    }
}

- (void)thinningButtonTapped
{
    [self.pcxAnalizer thinningDevides];
    [self.pcxView setNeedsDisplay];
}

@end



