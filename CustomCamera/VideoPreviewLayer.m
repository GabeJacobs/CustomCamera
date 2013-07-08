//
//  VideoPreviewLayer.m
//  CustomCamera
//
//  Created by Gabe Jacobs on 6/17/13.
//  Copyright (c) 2013 Gabe Jacobs. All rights reserved.
//

#import "VideoPreviewLayer.h"
#import "CaptureSessionManager.h"

@implementation VideoPreviewLayer

@synthesize captureManager;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      
    }
    return self;
}
- (void)awakeFromNib
{
    self.focusRing = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"circle.png"]];
    [self addSubview:self.focusRing];
    self.focusRing.hidden = YES;

    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [touches enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        UITouch *touch = obj;
        CGPoint touchPoint = [touch locationInView:self];
        

        self.focusRing.hidden = NO;
        [self bringSubviewToFront:self.focusRing];

        
        
            double screenWidth = self.frame.size.width;
            double screenHeight = self.frame.size.height;

            double focus_x = touchPoint.y/screenHeight;
            double focus_y = touchPoint.x/screenWidth;
            focus_y = 1.000000000 - focus_y; // setFocusPointOfInterest: takes a CGPoint takes a point ranging from (0,0) to (1,1) where (0,0) is the top left and (1,1) is the bottom right.
               
                [self autoFocusAtPoint:CGPointMake(focus_x,focus_y)];
            
                self.focusRing.alpha = 1.0;
                [self.focusRing setCenter:CGPointMake(touchPoint.x,touchPoint.y)];
                
                [UIView beginAnimations:@"fade in" context:nil];
                [UIView setAnimationDuration:1.65];
                self.focusRing.alpha = 0.0;
                [UIView commitAnimations];
         
    }];
}



- (void) autoFocusAtPoint:(CGPoint)point
{
    

   NSArray *devices = [AVCaptureDevice devices];
   
        for (AVCaptureDevice *device in devices) {
            [device unlockForConfiguration];

            
            if ([device hasMediaType:AVMediaTypeVideo]) {
               // NSLog(@"here!");
                
                if([device isExposurePointOfInterestSupported] &&
                   [device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
                    if([device lockForConfiguration:nil]) {
                        
                        if([device position] == AVCaptureDevicePositionFront) {

                            NSLog(@"x: %f y: %f",point.x,point.y);
                            point.y = 1.000 - point.y; // front gets flipped
                            NSLog(@"x: %f y: %f",point.x,point.y);

                            [device setExposurePointOfInterest:point];
                            [device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
                        }
                        else{
                            [device setExposurePointOfInterest:point];
                            [device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];

                        }
                    }
                
                }
                if([device isFocusPointOfInterestSupported] &&
                    [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
                 //   NSLog(@"all things supported!");

                    if([device lockForConfiguration:nil]) {
                    //    NSLog(@"all things supported2!");

                        [device setFocusPointOfInterest:point];
                        [device setFocusMode:AVCaptureFocusModeAutoFocus];
        
                        [device lockForConfiguration:nil];
            
                    }
                }
            }
        }
}

@end
