//
//  ConfirmationViewController.m
//  CustomCamera
//
//  Created by Gabe Jacobs on 6/18/13.
//  Copyright (c) 2013 Gabe Jacobs. All rights reserved.
//

#import "ConfirmationViewController.h"

@interface ConfirmationViewController ()

@end

@implementation ConfirmationViewController

@synthesize image;
@synthesize twoFingerPinch;


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
    
    [self.imageView setImage:self.image];
    [self checkOrientation];
    /*
    self.imageView.userInteractionEnabled = YES;
    self.imageView.backgroundColor = [UIColor clearColor];
    self.imageView.contentMode =  UIViewContentModeCenter;
    
    self.twoFingerPinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(twoFingerPinch:)];
    [self.imageView addGestureRecognizer:twoFingerPinch];
*/

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)confirmPhoto:(id)sender {
    
     [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelPhoto:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)twoFingerPinch:(UIPinchGestureRecognizer *)recognizer
{
    /*
    //    NSLog(@"Pinch scale: %f", recognizer.scale);
    if (recognizer.scale >1.0f && recognizer.scale < 2.5f) {
        CGAffineTransform transform = CGAffineTransformMakeScale(recognizer.scale, recognizer.scale);
        self.imageView.transform = transform;
    }
     */
}

-(void)checkOrientation{
    

    if (self.image.imageOrientation == UIImageOrientationLeft || self.image.imageOrientation == UIImageOrientationRight) {
        NSLog(@"portrait");
    } else if (self.image.imageOrientation == UIImageOrientationUp || self.image.imageOrientation == UIImageOrientationDown) {
        NSLog(@"landscape");
        CGRect frame = [self.imageView frame];
        frame.size.height = 247;
        [self.imageView setFrame:frame];
    }
    CGRect frame = [self.imageView frame];
    NSLog(@"%f",frame.size.height);
    
    
    
}
@end
