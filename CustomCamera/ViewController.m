//
//  ViewController.m
//  CustomCamera
//
//  Created by Gabe Jacobs on 6/14/13.
//  Copyright (c) 2013 Gabe Jacobs. All rights reserved.
//

#import "ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ConfirmationViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize captureManager;
@synthesize lastImage;
@synthesize flashVar;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self setCaptureManager:[[CaptureSessionManager alloc] init]];
    
	[[self captureManager] addVideoInput];
    
	[[self captureManager] addVideoPreviewLayer];
    
    CGRect rect1 = CGRectMake(160, 213, 320, 426);
    [self.previewLayer.layer addSublayer:[[self captureManager] previewLayer]];

	[[[self captureManager] previewLayer] setBounds:rect1];
	[[[self captureManager] previewLayer] setPosition:CGPointMake(160, 213)];
    [self.previewLayer.layer addSublayer:[[self captureManager] previewLayer]];

    [[self view] bringSubviewToFront:self.topBar];
    [[self view] bringSubviewToFront:self.flashButton];
    [[self view] bringSubviewToFront:self.flashLabel];
    [[self view] bringSubviewToFront:self.flipButton];
    [[self view] bringSubviewToFront:self.imageCaptured];
    self.imageCaptured.alpha = 0.0;

	[[captureManager captureSession] startRunning];
    
    [[self captureManager] addStillImageOutput];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveImageToPhotoAlbum) name:kImageCapturedSuccessfully object:nil];
    
    self.flashVar = 0;
    AVCaptureDevice* device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device lockForConfiguration:nil]; //you must lock before setting torch mode
    [device setFlashMode:AVCaptureFlashModeAuto];
    [device unlockForConfiguration];
    
    [self.flashButton setTitle:@"Auto" forState: UIControlStateNormal];
     

    [self.flashButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    
    [self getLastPictureTaken];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)useCamera:(id)sender {
    
    [[self captureManager] captureStillImage];
    self.imageCaptured.alpha = 1.0;

    [UIView beginAnimations:@"fade in" context:nil];
    [UIView setAnimationDuration:1.5];
     self.imageCaptured.alpha = 0.0;
    [UIView commitAnimations];


    NSLog(@"%@",self.navigationController);

}


- (IBAction)flipCamera:(id)sender {
    
    [[self captureManager] switchCamera];

}

- (IBAction)useCameraRoll:(id)sender {
    
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                  (NSString *) kUTTypeImage,
                                  nil];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    
}

-(void) getLastPictureTaken
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        
        [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:[group numberOfAssets] - 1] options:0 usingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop) {
            
            if (alAsset) {
                ALAssetRepresentation *representation = [alAsset defaultRepresentation];
                UIImage *latestPhoto = [UIImage imageWithCGImage:[representation fullScreenImage]];
                
                self.lastImage.image = latestPhoto;
            }
        }];
    } failureBlock: ^(NSError *error) {
        NSLog(@"No photos?");
    }];
}

- (void)saveImageToPhotoAlbum
{
    UIImageWriteToSavedPhotosAlbum([[self captureManager] stillImage], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    ConfirmationViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"confirmationController"];
    
    [cvc setImage:[[self captureManager] stillImage]];

    [self.navigationController pushViewController:cvc animated:YES];
    //[cvc setImage:[[self captureManager] stillImage]];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    [self getLastPictureTaken];

    if (error != NULL) {
        NSLog(@"ERROR PICTURE NOT SAVED!");

    }
    else {
        NSLog(@"PICTURE SAVED!");
    }
}


- (IBAction)changeFlash:(id)sender {
    self.flashVar++;
    if(self.flashVar == 0)
    {
        [self.flashButton setTitle:@"Auto" forState: UIControlStateNormal];
        [self.flashButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        AVCaptureDevice* device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        [device lockForConfiguration:nil]; //you must lock before setting torch mode
        [device setFlashMode:AVCaptureFlashModeOff];
        [device unlockForConfiguration];

    }
    if(self.flashVar == 1)
    {
        [self.flashButton setTitle:@"On" forState: UIControlStateNormal];
        [self.flashButton setTitleColor:[UIColor colorWithRed:64.0f/255.0f green:168.0f/255.0f blue:92.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        AVCaptureDevice* device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        [device lockForConfiguration:nil]; //you must lock before setting torch mode
        [device setFlashMode:AVCaptureFlashModeOn];
        [device unlockForConfiguration];
        
    }
    if(self.flashVar == 2)
    {
        [self.flashButton setTitle:@"Off" forState: UIControlStateNormal];
        [self.flashButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        AVCaptureDevice* device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        [device lockForConfiguration:nil]; //you must lock before setting torch mode
        [device setFlashMode:AVCaptureFlashModeOff];
        [device unlockForConfiguration];
        self.flashVar = -1;

    }

}

@end
