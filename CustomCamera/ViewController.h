//
//  ViewController.h
//  CustomCamera
//
//  Created by Gabe Jacobs on 6/14/13.
//  Copyright (c) 2013 Gabe Jacobs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaptureSessionManager.h"
#import "VideoPreviewLayer.h"

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>


- (IBAction)useCameraRoll:(id)sender;
- (IBAction)useCamera:(id)sender;
- (IBAction)flipCamera:(id)sender;
- (IBAction)changeFlash:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *flashLabel;
@property (weak, nonatomic) IBOutlet UIImageView *topBar;
@property (weak, nonatomic) IBOutlet UIButton *flipButton;
@property (weak, nonatomic) IBOutlet UIButton *flashButton;
@property (weak, nonatomic) IBOutlet UIImageView *lastImage;
@property (weak, nonatomic) IBOutlet UILabel *imageCaptured;
@property (nonatomic) NSInteger flashVar;
@property (retain) CaptureSessionManager *captureManager;
@property (weak, nonatomic) IBOutlet VideoPreviewLayer *previewLayer;

- (void)getLastPictureTaken;
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;

@end
