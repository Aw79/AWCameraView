//
// 	AWCameraViewDelegate.h
//  AWCameraView
//
//  Created by James Billingham on 25/08/2015.
//  Copyright (c) 2015 Cuvva Limited
//  Copyright (c) 2013 www.verylargebox.com
//

#import <Foundation/Foundation.h>
#import <AWCameraView/AWCameraViewCaptureConnectionType.h>

@class AWCameraView;
@class AVCaptureConnection;
@class UIImage;

@protocol AWCameraViewDelegate <NSObject>

/// Called after the picture is captured if an error didn't occur
- (void)cameraView:(AWCameraView *)cameraView didFinishTakingPicture:(UIImage *)image withInfo:(NSDictionary *)info;

/// Called if an error occurs while picture is being captured
- (void)cameraView:(AWCameraView *)cameraView didErrorOnTakePicture:(NSError *)error;

@optional

/// Called to allow customization of the underlying AVCaptureConnection
- (void)cameraView:(AWCameraView *)cameraView didCreateCaptureConnection:(AVCaptureConnection *)captureConnection withCaptureConnectionType:(AWCameraViewCaptureConnectionType)captureConnectionType;

@end
