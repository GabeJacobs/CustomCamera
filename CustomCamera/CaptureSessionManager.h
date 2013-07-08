#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>


#define kImageCapturedSuccessfully @"imageCapturedSuccessfully"


@interface CaptureSessionManager : NSObject {
     int test;


}

@property (retain) AVCaptureVideoPreviewLayer *previewLayer;
@property (retain) AVCaptureSession *captureSession;
@property (retain) AVCaptureDeviceInput *frontFacingCameraDeviceInput;
@property (retain) AVCaptureDeviceInput *backCameraDeviceInput;

@property (nonatomic) BOOL frontCameraOn;

@property (retain) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, retain) UIImage *stillImage;



- (void)addVideoPreviewLayer;
- (void)addVideoInput;
- (void)switchCamera;
- (void)addStillImageOutput;
- (void)captureStillImage;

@end
