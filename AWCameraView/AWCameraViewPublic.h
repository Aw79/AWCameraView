//
// 	AWCameraView.h
//  AWCameraView
//
//  Created by Markos Charatzas on 25/06/2013.
//  Copyright (c) 2015 Cuvva Limited
//  Copyright (c) 2013 www.verylargebox.com
//

#import <UIKit/UIKit.h>
#import "AWCameraViewPosition.h"
#import "AWCameraViewDelegate.h"

/// UIView to show the camera, take a picture, preview it, return UIImage
@interface AWCameraView : UIView

/// Delegate for receiving events
@property (weak, nonatomic) IBOutlet UIViewController<AWCameraViewDelegate> *delegate;

/// The camera-position being used - front or back; defaults to back
@property (assign, nonatomic) AWCameraViewPosition position;

/// If enabled, focus the camera-view on the position of the tap
/// Disabled by default
@property (assign, nonatomic) BOOL enableFocusOnTap;

/// Takes a still image of the current frame from the video feed
- (void)takePicture;

/// Restart the session
- (void)retakePicture;

/// Focus on Point
- (void)focusOnPoint:(CGPoint)point;

@end
