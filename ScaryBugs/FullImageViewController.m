//
//  FullImageViewController.m
//  ScaryBugs
//
//  Created by chenjs on 12-11-3.
//  Copyright (c) 2012年 HelloTom. All rights reserved.
//

#import "FullImageViewController.h"

@interface FullImageViewController ()

@end

@implementation FullImageViewController

@synthesize imageView;
@synthesize imageToDisplay = _imageToDisplay;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    if (self.imageToDisplay != nil) {
        self.imageView.image = self.imageToDisplay;
    }
    
    //[self resizeImageView];
    
    UISwipeGestureRecognizer *swipGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewSwapped)];
    swipGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped)];
    tapGestureRecognizer.numberOfTapsRequired = 2;
     
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:swipGestureRecognizer];
    [self.imageView addGestureRecognizer:tapGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self resizeImageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self resizeImageView];
    
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (void)resizeImageView
{
    CGRect rectScreen = [[UIScreen mainScreen] bounds];
    
    if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
        
        if (self.imageToDisplay.size.width < self.imageToDisplay.size.height) {
            
            float ratio = rectScreen.size.width / self.imageToDisplay.size.height;
            int width = round(self.imageToDisplay.size.width * ratio);
            int x = (rectScreen.size.height - width) / 2;
            CGRect newRect = CGRectMake(x, 0, width, rectScreen.size.width);
            self.imageView.frame = newRect;
            
        } else {
            
            CGRect fullRect = CGRectMake(0, 0, rectScreen.size.height, rectScreen.size.width);
            self.imageView.frame = fullRect;
        }
        
    } else {
        
        if (self.imageToDisplay.size.width < self.imageToDisplay.size.height) {
            
            CGRect fullRect = CGRectMake(0, 0, rectScreen.size.width, rectScreen.size.height);
            self.imageView.frame = fullRect;
        } else {
            
            float ratio = rectScreen.size.width / self.imageToDisplay.size.width;
            int height = round(self.imageToDisplay.size.height * ratio);
            int y = (rectScreen.size.height - height) / 2;
            
            CGRect newRect = CGRectMake(0, y, rectScreen.size.width, height);
            self.imageView.frame = newRect;
        }
    }
}


- (void)dealloc
{
    //NSLog(@"%@ dealloc", self);
}

- (void)imageViewSwapped
{
    [self exitFullImageMode];
}

- (void)imageViewTapped
{
    [self exitFullImageMode];
}

- (void)exitFullImageMode
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self dismissModalViewControllerAnimated:YES];
}

@end
