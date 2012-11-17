//
//  DetailViewController.h
//  ScaryBugs
//
//  Created by chenjs on 12-10-31.
//  Copyright (c) 2012年 HelloTom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateView.h"

@class ScaryBugDoc;

@interface DetailViewController : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, RateViewDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) ScaryBugDoc *bugDoc;

@property (strong, nonatomic) IBOutlet UITextField *titleField;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet RateView *rateView;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) IBOutlet UILabel *labelTapTip;

- (IBAction)titleTextChanged:(id)sender;

- (void)setBugDocItem:(ScaryBugDoc *)theBugDoc;

@end
