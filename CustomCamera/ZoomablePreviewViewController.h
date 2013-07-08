//
//  ZoomablePreviewViewController.h
//  CustomCamera
//
//  Created by Gabe Jacobs on 6/19/13.
//  Copyright (c) 2013 Gabe Jacobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZoomablePreviewViewController : UIImageView <UIGestureRecognizerDelegate>{
    UIPanGestureRecognizer *panGesture;
}

@property(nonatomic) BOOL isZoomable;

- (void) applyGestures;
- (void) scaleToMinimum;

- (void)pinch:(UIPinchGestureRecognizer *)gesture;
- (void)pan:(UIPanGestureRecognizer *)gesture;
- (void)doubleTap:(UITapGestureRecognizer *)gesture;

@end