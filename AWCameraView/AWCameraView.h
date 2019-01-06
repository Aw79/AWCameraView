//
//  AWCameraView.h
//  AWCameraView
//
//  Created by Andreas Wörner on 06.01.19.
//  Copyright © 2019 aw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AWCameraView/AWCameraViewPosition.h>
#import <AWCameraView/AWCameraViewDelegate.h>

//! Project version number for AWCameraView.
FOUNDATION_EXPORT double AWCameraViewVersionNumber;

//! Project version string for AWCameraView.
FOUNDATION_EXPORT const unsigned char AWCameraViewVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <AWCameraView/PublicHeader.h>


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
