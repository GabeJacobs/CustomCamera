//
//  VideoPreviewLayer.h
//  CustomCamera
//
//  Created by Gabe Jacobs on 6/17/13.
//  Copyright (c) 2013 Gabe Jacobs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaptureSessionManager.h"

@interface VideoPreviewLayer : UIView

@property (retain) CaptureSessionManager *captureManager;
@property (retain) UIImageView *focusRing;

- (void) autoFocusAtPoint:(CGPoint)point;

@end
