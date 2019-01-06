//
// 	AWCameraView.m
//  AWCameraView
//
//  Created by Markos Charatzas on 25/06/2013.
//  Copyright (c) 2015 Cuvva Limited
//  Copyright (c) 2013 www.verylargebox.com
//

#import "AWCameraViewPublic.h"
#import <AVFoundation/AVFoundation.h>

@interface AWCameraView () <UIAlertViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) AVCaptureConnection *stillImageConnection;
@property (nonatomic, strong) UIImageView *preview;
@property (nonatomic) UITapGestureRecognizer *focusOnTapGestureRecognizer;

@end

@implementation AWCameraView

- (void)commonInit {
    self.session = [AVCaptureSession new];
    self.session.sessionPreset = AVCaptureSessionPresetPhoto;
    
    self.stillImageOutput = [AVCaptureStillImageOutput new];
    self.stillImageOutput.outputSettings = @{AVVideoCodecKey:AVVideoCodecJPEG};
    [self.session addOutput:self.stillImageOutput];
    
    self.videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
}

- (id)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) {
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (!(self = [super initWithCoder:aDecoder])) {
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.session startRunning];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    self.preview = [[UIImageView alloc] initWithFrame:frame];
    [self addSubview:self.preview];
    
    self.videoPreviewLayer.frame = frame;
    [self.layer addSublayer:self.videoPreviewLayer];
}

- (void) setEnableFocusOnTap:(BOOL)enable {
    _enableFocusOnTap = enable;
    
    if(enable) {
        if(!self.focusOnTapGestureRecognizer) {
            self.focusOnTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleFocusOnTap:)];
            self.focusOnTapGestureRecognizer.numberOfTapsRequired = 1;
            self.focusOnTapGestureRecognizer.delegate = self;
        }
        [self addGestureRecognizer:self.focusOnTapGestureRecognizer];
    }
    else {
        self.focusOnTapGestureRecognizer.delegate = nil;
        [self removeGestureRecognizer:self.focusOnTapGestureRecognizer];
        self.focusOnTapGestureRecognizer = nil;
    }
}

- (void)takePicture {
    __weak AWCameraView *weakSelf = self;
    
    [self.stillImageOutput
     captureStillImageAsynchronouslyFromConnection:self.stillImageConnection
     completionHandler:^(CMSampleBufferRef sampleBuffer, NSError *error) {
         [weakSelf.session stopRunning];
         
         if (error) {
             [self.delegate cameraView:weakSelf didErrorOnTakePicture:error];
             return;
         }
         
         NSData *data = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:sampleBuffer];
         UIImage *image = [UIImage imageWithData:data];
         CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, sampleBuffer, kCMAttachmentMode_ShouldPropagate);
         NSDictionary *info = CFBridgingRelease(attachments);
         
         [self.delegate cameraView:weakSelf didFinishTakingPicture:image withInfo:info];
         
         dispatch_async(dispatch_get_main_queue(), ^{
             weakSelf.preview.image = image;
         });
     }];
}

- (void)retakePicture {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.preview.image = nil;
        [self.session startRunning];
    });
}

- (void)focusOnPoint:(CGPoint)point {
    AVCaptureDevice *device = [self getCameraWithPosition:self.position];
    if([device lockForConfiguration:nil]) {
        if([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            device.focusPointOfInterest = point;
            device.focusMode = AVCaptureFocusModeAutoFocus;
        }
        if([device isExposurePointOfInterestSupported] && [device isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
            device.focusPointOfInterest = point;
            device.exposureMode = AVCaptureExposureModeAutoExpose;
        }
    }
    [device unlockForConfiguration];
}

- (void)handleFocusOnTap:(UIGestureRecognizer *)recognizer {
    CGPoint absPoint = [recognizer locationInView:self];
    CGPoint relPoint = CGPointMake(absPoint.x / self.frame.size.width, absPoint.y / self.frame.size.height);
    
    [self focusOnPoint:relPoint];

    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.cancelButtonIndex) {
        [self setPosition:self.position];
    }
    
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

- (void)setPosition:(AWCameraViewPosition)position {
    _position = position;
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            [self setPosition:self.position];
        }];
        return;
    }
    
    if (status != AVAuthorizationStatusAuthorized) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Camera Required"
                                                                       message:@"To continue, you must allow access to the camera."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Try Again"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
                                                                 [self setPosition:self.position];
                                                             }];
        [alert addAction:cancelAction];

        UIAlertAction* settingsAction = [UIAlertAction actionWithTitle:@"Settings"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action) {
                                                                   [[UIApplication sharedApplication]
                                                                    openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                                               }];
        [alert addAction:settingsAction];
        
        [self.delegate presentViewController:alert animated:NO completion:nil];

        return;
    }
    
    AVCaptureDevice *device = [self getCameraWithPosition:self.position];
    
    if (!device) {
        [NSException raise:@"CameraUnavailable" format:@"Failed to get a capture device"];
    }
    
    if ([device lockForConfiguration:nil]) {
        if ([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
            device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
        }
        
        if ([device isFlashModeSupported:AVCaptureFlashModeAuto]) {
            device.flashMode = AVCaptureFlashModeAuto;
        }
        
        [device unlockForConfiguration];
    }
    
    NSError *error;
    AVCaptureDeviceInput *deviceInput;
    if (!(deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error])) {
        NSString *str = [NSString stringWithFormat:@"Failed with error %d", (int)error.code];
        [NSException raise:str format:@"%@", error.localizedDescription];
    }
    
    for (AVCaptureDeviceInput *input in self.session.inputs) {
        [self.session removeInput:input];
    }
    
    [self.session addInput:deviceInput];
    
    self.stillImageConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    self.stillImageConnection.videoOrientation = AVCaptureVideoOrientationPortrait;
    
    if ([self.delegate respondsToSelector:@selector(cameraView:didCreateCaptureConnection:withCaptureConnectionType:)]) {
        [self.delegate cameraView:self didCreateCaptureConnection:self.stillImageConnection withCaptureConnectionType:AWCameraViewCaptureConnectionTypeStillImage];
    }
    
    if ([self.delegate respondsToSelector:@selector(cameraView:didCreateCaptureConnection:withCaptureConnectionType:)]) {
        [self.delegate cameraView:self didCreateCaptureConnection:self.videoPreviewLayer.connection withCaptureConnectionType:AWCameraViewCaptureConnectionTypeVideoPreview];
    }
}

- (AVCaptureDevice *)getCameraWithPosition:(AWCameraViewPosition)position {
    AVCaptureDevicePosition avPosition = [self avPositionForPosition:position];
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    for (AVCaptureDevice *device in devices) {
        if (device.position == avPosition) {
            return device;
        }
    }
    
    return devices.firstObject;
}

- (AVCaptureDevicePosition)avPositionForPosition:(AWCameraViewPosition)position {
    switch (position) {
        case AWCameraViewPositionBack:
            return AVCaptureDevicePositionBack;
        case AWCameraViewPositionFront:
            return AVCaptureDevicePositionFront;
        default:
            [NSException raise:@"InvalidPosition" format:@"Invalid position"];
    }
}

@end
