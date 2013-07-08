#import "CaptureSessionManager.h"
#import <ImageIO/ImageIO.h>
#import "ViewController.h"
#import "ConfirmationViewController.h"

@implementation CaptureSessionManager

@synthesize captureSession;
@synthesize previewLayer;
@synthesize frontFacingCameraDeviceInput;
@synthesize backCameraDeviceInput;
@synthesize stillImage;
@synthesize stillImageOutput;
@synthesize frontCameraOn;

#pragma mark Capture Session Configuration



- (id)init {
	if ((self = [super init])) {
		[self setCaptureSession:[[AVCaptureSession alloc] init]];
	}
	return self;
}

- (void)addVideoPreviewLayer {
	[self setPreviewLayer:[[AVCaptureVideoPreviewLayer alloc] initWithSession:[self captureSession]] ];
   self.captureSession.sessionPreset = AVCaptureSessionPresetPhoto;

	[[self previewLayer] setVideoGravity:AVLayerVideoGravityResizeAspect];

  
}

- (void)addVideoInput {
    NSArray *devices = [AVCaptureDevice devices];
    AVCaptureDevice *frontCamera;
    AVCaptureDevice *backCamera;
    
    for (AVCaptureDevice *device in devices) {
        
        if ([device hasMediaType:AVMediaTypeVideo]) {
            
            if ([device position] == AVCaptureDevicePositionBack) {
                backCamera = device;
            }
            else {
                frontCamera = device;
            }
        }
    }
    
    NSError *error = nil;
    self.frontFacingCameraDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:frontCamera error:&error];
    self.backCameraDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:&error];

    if (!error) {
        if ([[self captureSession] canAddInput:self.backCameraDeviceInput])
        {
            [[self captureSession] addInput:self.backCameraDeviceInput];
            [[self captureSession] commitConfiguration];
            self.frontCameraOn = NO;
        }
        else {
            NSLog(@"Couldn't add front facing video input");
        }
    }
}


- (void)switchCamera {
    
    test = 1;
    if(self.frontCameraOn)
    {
        //NSLog(@"switching front off");
        [[self captureSession] removeInput:self.frontFacingCameraDeviceInput];
        [[self captureSession] addInput:self.backCameraDeviceInput];
        [[self captureSession] commitConfiguration];

        [self setFrontCameraOn:NO];
        
    }
    else{
        NSLog(@"switching front on");
        [[self captureSession] removeInput:self.backCameraDeviceInput];
        [[self captureSession] addInput:self.frontFacingCameraDeviceInput];
        [[self captureSession] commitConfiguration];

        [self setFrontCameraOn:YES];

    }
    
    //[self addStillImageOutput];
}

- (void)addStillImageOutput
{
    [self setStillImageOutput:[[AVCaptureStillImageOutput alloc] init]];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    [[self stillImageOutput] setOutputSettings:outputSettings];


    [[self captureSession] addOutput:[self stillImageOutput]];
}

- (void)captureStillImage
{
	AVCaptureConnection *videoConnection = nil;
	for (AVCaptureConnection *connection in [[self stillImageOutput] connections]) {
		for (AVCaptureInputPort *port in [connection inputPorts]) {
			if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
				videoConnection = connection;
				break;
			}
		}
		if (!videoConnection) {
            NSLog(@"NO VIDEO INPUT FOUND!");
            break;
        }
	}

    NSLog(@"about to request a capture from: %@", [self stillImageOutput]);
	[[self stillImageOutput] captureStillImageAsynchronouslyFromConnection:videoConnection
                                                         completionHandler:^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
                                                             CFDictionaryRef exifAttachments = CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
                                                             if (exifAttachments) {
                                                                // NSLog(@"attachements: %@", exifAttachments);
                                                             } else {
                                                                 //NSLog(@"no attachments");
                                                             }
                                                             NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
                                                             UIImage *image = [[UIImage alloc] initWithData:imageData];

                                                             // AVFoundation automatically takes portrait shots as UIImageOrientation left. Doesn't make sense. Not sure if Apple is stupid or I am doing it wrong.
                                                             
                                                             if(!self.frontCameraOn)
                                                             {
                                                                if (([UIDevice currentDevice].orientation) == UIDeviceOrientationLandscapeLeft){
                                                                    image = [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:UIImageOrientationUp];
                                                                    }
                                                                else if (([UIDevice currentDevice].orientation) == UIDeviceOrientationLandscapeRight){
                                                                    image = [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:UIImageOrientationDown];
                                                                }
                                                             }
                                                             else{
                                                                 if (([UIDevice currentDevice].orientation) == UIDeviceOrientationLandscapeLeft){
                                                                     image = [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:UIImageOrientationDown];
                                                                 }
                                                                 else if (([UIDevice currentDevice].orientation) == UIDeviceOrientationLandscapeRight){
                                                                     image = [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:UIImageOrientationUp];
                                                                 }
                                                             }
                                                             [self setStillImage:image];

                                                             
                                                             [[NSNotificationCenter defaultCenter] postNotificationName:kImageCapturedSuccessfully object:nil];
                                                         }];
}


@end
