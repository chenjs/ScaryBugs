//
//  DetailViewController.m
//  ScaryBugs
//
//  Created by chenjs on 12-10-31.
//  Copyright (c) 2012年 HelloTom. All rights reserved.
//

#import "DetailViewController.h"
#import "ScaryBugDoc.h"
#import "ScaryBugData.h"
#import "RateView.h"
#import "UIImageExtras.h"
#import "SVProgressHUD.h"
#import "FullImageViewController.h"

@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController {
    CGRect imageViewNormalRect;
    BOOL isBusying;
}

@synthesize bugDoc = _bugDoc;
@synthesize titleField = _titleField;
@synthesize imageView = _imageView;
@synthesize imagePicker = _imagePicker;
@synthesize rateView = _rateView;
@synthesize labelTapTip = _labelTapTip;


#pragma mark - Managing the detail item


- (void)setBugDocItem:(ScaryBugDoc *)theBugDoc
{
    if (_bugDoc != theBugDoc) {
        _bugDoc = theBugDoc;
        
        [self configureView];
    }
}

- (void)defaultRateView
{
    self.rateView.notSelectedImage = [UIImage imageNamed:@"shockedface2_empty"];
    self.rateView.halfSelectedImage = [UIImage imageNamed:@"shockedface2_half"];
    self.rateView.fullSelectedImage = [UIImage imageNamed:@"shockedface2_full"];
    self.rateView.maxRating = 5;
    self.rateView.editable = YES;
    self.rateView.delegate = self;
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.bugDoc) {
        self.titleField.text = self.bugDoc.data.title;
        if (self.bugDoc.fullImage != nil) {
            self.imageView.image = self.bugDoc.fullImage;
            self.labelTapTip.hidden = YES;
        } else {
            self.labelTapTip.hidden = NO;
        }
        self.rateView.rating = self.bugDoc.data.rating;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self defaultRateView];
    [self configureView];
    
    imageViewNormalRect = self.imageView.frame;
    
    isBusying = NO;
    
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewLongPressed)];
    
    /*
    UISwipeGestureRecognizer *swipGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewSwapped)];
    swipGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    */
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    
    self.imageView.userInteractionEnabled = YES;
    //[self.imageView addGestureRecognizer:swipGestureRecognizer];
    [self.imageView addGestureRecognizer:tapGestureRecognizer];
    [self.imageView addGestureRecognizer:longPressGestureRecognizer];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTitleField:nil];
    [self setImageView:nil];
    [self setRateView:nil];
    [self setLabelTapTip:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (IBAction)titleTextChanged:(id)sender
{
    self.bugDoc.data.title = self.titleField.text;
    
    [self.bugDoc saveData];
}

- (void)chooseImage
{
    if (isBusying) {
        //NSLog(@"chooseImage, is busy now ");
        return;
    }
    
    isBusying = YES;
    
    if (self.imagePicker == nil) {
        [SVProgressHUD showWithStatus:@"Loading ..."];
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            
            self.imagePicker = [[UIImagePickerController alloc] init];
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            self.imagePicker.delegate = self;
            self.imagePicker.editing = NO;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.navigationController presentModalViewController:self.imagePicker animated:YES];
                [SVProgressHUD dismiss];
            });
            
        });
            
    } else {
        [self.navigationController presentModalViewController:self.imagePicker animated:YES];
    }
}

- (void)imageViewTapped
{
    if (self.bugDoc != nil && self.bugDoc.fullImage != nil) {
        [self performSegueWithIdentifier:@"ShowFullImage" sender:nil];
        //[self chooseImage];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowFullImage"]) {
        
        FullImageViewController *controller = (FullImageViewController *)segue.destinationViewController;
        controller.imageToDisplay = self.bugDoc.fullImage;
    }
}

- (void)imageViewLongPressed
{
    [self chooseImage];
}

- (void)imageViewSwapped
{
    //[self performSegueWithIdentifier:@"ShowFullImage" sender:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.titleField resignFirstResponder];
    return YES;
}


#pragma mark - RateViewDelegate

- (void)rateView:(RateView *)rateView ratingDidChange:(float)rating
{
    self.bugDoc.data.rating = rating;
    
    [self.bugDoc saveData];
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissModalViewControllerAnimated:YES];
    
    UIImage *fullImage = [info objectForKey:UIImagePickerControllerOriginalImage];

    [SVProgressHUD showWithStatus:@"Resizing image..."];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        UIImage *thumbImage = [fullImage imageByScalingAndCroppingForSize:CGSizeMake(44, 44)];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.bugDoc.fullImage = fullImage;
            //self.bugDoc.fullImage = [fullImage fixOrientation];
            self.bugDoc.thumbImage = thumbImage;
            self.imageView.image = fullImage;
            
            [self.bugDoc saveImages];
            
            [SVProgressHUD dismiss];
            
            isBusying = NO;
        });
    });
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
    
    isBusying = NO;
}


@end
