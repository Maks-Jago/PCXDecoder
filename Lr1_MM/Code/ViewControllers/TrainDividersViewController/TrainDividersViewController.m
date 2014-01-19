//
//  TrainDividersViewController.m
//  Lr1_MM
//
//  Created by Max Kuznetsov on 12.01.14.
//  Copyright (c) 2014 111Minutes. All rights reserved.
//

#import "TrainDividersViewController.h"
#import "PCXView.h"
#import "PCXDivideView.h"
#import "Recognizer.h"

@interface TrainDividersViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) PCXAnalizer *pcxAnalizer;
@property (nonatomic, strong) PCXContent *pcxContent;
@property (nonatomic, strong) PCXFile *pcxFile;
@property (nonatomic, assign) CGRect currentDivide;

@property (weak, nonatomic) IBOutlet PCXView *pcxView;
@property (weak, nonatomic) IBOutlet PCXDivideView *divideView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *letterTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TrainDividersViewController

- (id)initWithPCXContent:(PCXContent *)content pcxAnalizer:(PCXAnalizer *)analizer pcxFile:(PCXFile *)pcxFile
{
    self = [super init];
    if (self) {
        self.pcxContent = content;
        self.pcxAnalizer = analizer;
        self.pcxFile = pcxFile;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.divideView.pcxAnalizer = self.pcxView.pcxAnalizer = self.pcxAnalizer;
    self.divideView.pcxFile = self.pcxView.pcxFile = self.pcxFile;
    
    __weak TrainDividersViewController *weakSelf = self;
    self.pcxView.touchBlock = ^(UITouch *touch) {
        CGPoint location = [touch locationInView:weakSelf.pcxView];
        for (NSValue *value in [weakSelf.pcxAnalizer devide]) {
            CGRect divider = [value CGRectValue];
            if (CGRectContainsPoint(divider, location)) {
                [weakSelf.divideView setDivide:divider];
                weakSelf.currentDivide = divider;
                break;
            }
        }
    };
    
    [self.pcxView setNeedsDisplay];
    
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.scrollView.showsVerticalScrollIndicator = self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor lightGrayColor];
    self.scrollView.scrollEnabled = YES;
    
    self.scrollView.minimumZoomScale = self.scrollView.frame.size.width / self.pcxView.frame.size.width;
    self.scrollView.maximumZoomScale = 1000.0;
//    self.scrollView.zoomScale = self.scrollView.minimumZoomScale + 0.5;
    [self.scrollView setZoomScale:self.scrollView.minimumZoomScale + 0.5 animated:YES];
    self.scrollView.contentSize = self.pcxView.frame.size;
}


#pragma mark -
#pragma mark UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.pcxView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    [self.scrollView setContentOffset:CGPointMake(1, 1) animated:YES];
//    int index = 1;
//    for (NSValue *value in [self.pcxAnalizer devide]) {
//        [self addTextViewForDivide:[value CGRectValue] withLetter:[NSString stringWithFormat:@"%d", index]];
//        index ++;
//    }
}


#pragma mark -
#pragma mark Actions

- (IBAction)trainButtonTapped:(id)sender
{
    NSString *letter = self.letterTextField.text;
    if (letter.length) {
        [[Recognizer shared] addMensurationForDivide:self.currentDivide letter:letter];
        [self.divideView setDivide:CGRectZero];
        self.letterTextField.text = @"";
        [self.letterTextField resignFirstResponder];
    }
}

- (IBAction)recognizeButtonTapped:(id)sender
{
    [[self.pcxView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSArray *divides = [self.pcxAnalizer devide];
    CGRect previousRect = CGRectZero;
    NSMutableString *string = [NSMutableString new];
    
    for (NSValue *value in divides) {
//        if (!CGRectContainsRect(previousRect, CGRectZero)) {
//            if ([value CGRectValue].origin.y > previousRect.origin.y + [value CGRectValue].size.height) {
//                [string appendString:@"\n"];
//            } else if (fabs(CGRectGetMaxX(previousRect) - CGRectGetMaxX([value CGRectValue])) > 50) {
//                [string appendString:@"  "];
//            }
//        }
        
        Mensuration *mensuration = [[Recognizer shared] recognizeDivide:[value CGRectValue]];
        if (mensuration) {
            [string appendFormat:@"%@", mensuration.letter];
            [self addTextViewForDivide:[value CGRectValue] withLetter:mensuration.letter];
        } else if (value != [divides lastObject]){
            [string appendString:@"?"];
        }
        
        previousRect = [value CGRectValue];
    }
    
    NSLog(@"string:\n%@", string);
}

- (void)addTextViewForDivide:(CGRect)divide withLetter:(NSString *)letter
{
    UILabel *textView = [[UILabel alloc] initWithFrame:CGRectMake((divide.origin.x + divide.size.width / 2) - 10,
                                                                  (divide.origin.y) - 20,
                                                                  20, 20)];
    textView.backgroundColor = [UIColor clearColor];
    textView.text = letter;
    textView.textColor = [UIColor blueColor];
    textView.textAlignment = NSTextAlignmentCenter;
    [self.pcxView addSubview:textView];
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

#pragma mark -
#pragma mark UITableViewDelegate



@end
