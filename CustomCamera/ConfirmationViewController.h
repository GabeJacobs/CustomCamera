//
//  ConfirmationViewController.h
//  CustomCamera
//
//  Created by Gabe Jacobs on 6/18/13.
//  Copyright (c) 2013 Gabe Jacobs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaptureSessionManager.h"

@interface ConfirmationViewController : UIViewController
- (IBAction)confirmPhoto:(id)sender;
- (IBAction)cancelPhoto:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) UIImage *image;
@property (retain) CaptureSessionManager *captureManager;
@property (strong,nonatomic) UIPinchGestureRecognizer *twoFingerPinch;

- (void)twoFingerPinch:(UIPinchGestureRecognizer *)recognizer;
-(void)checkOrientation;
@end
