# `AWCameraView` 
[![Build Status](https://travis-ci.org/Aw79/AWCameraView.svg?branch=master)](https://travis-ci.org/Aw79/AWCameraView) [![License](https://cocoapod-badges.herokuapp.com/l/AWCameraView/badge.svg)](https://github.com/Aw79/AWCameraView/blob/master/LICENSE) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![Cocoapods](https://cocoapod-badges.herokuapp.com/v/AWCameraView/badge.png)](https://cocoapods.org/pods/AWCameraView) [![Cocoapods platforms](https://cocoapod-badges.herokuapp.com/p/AWCameraView/badge.png)](https://cocoapods.org/pods/AWCameraView)

(fork of JBCameraView)

UIView to show the camera, take a picture, preview it, return UIImage.

Even though an `UIImagePickerController` allows a custom overlay to override the
default camera controls, it gives you no control over its camera bounds. Instead
it captures a UIImage in full camera resolution, giving you the option to edit
as a second step.

Note: as of v0.3.0, you must specify the camera position before the camera will
activate.

## Installation

### Cocoapods
```ruby
pod 'AWCameraView'
```

### Carthage
```ruby
github 'Aw79/AWCameraView'
```

## Usage

### Interface Builder

* Drag a UIView into the interface and set its type to `AWCameraView`
* Set its delegate to a `UIViewController` that implements `AWCameraViewDelegate`
* Set the preferred camera position (will failover to the other one)
* Call `takePicture` on `AWCameraView` to receive the UIImage on your delegate
* Enable focus and exposure by setting `enableFocusOnTap`on `AWCameraView` or
* Call `focusOnPoint` on `AWCameraView` to focus on the given point (0,0) = top-left / (1,1) = bottom-right


### Code

```objc
AWCameraView *cameraView = [[AWCameraView alloc] initWithFrame:CGRect(320, 320)];
cameraView.delegate = self;
cameraView.position = AWCameraViewPositionBack;

/// Take a picture
[cameraView takePicture];

/// Enable tap-on-focus for camera-view; no need to call 'focusOnPoint'
cameraView.enableFocusOnTap = YES;

/// (Manually) focus on top-left point of camera-view
[cameraView focusOnPoint:CGPointMake(0, 0)];

/// (Manually) focus on bottom-right point of camera-view
[cameraView focusOnPoint:CGPointMake(1, 1)];
```

## Support

Please open an issue on this repository.

## Authors

- Andreas Woerner <awoerner@gmx.net>
- James Billingham <james@jamesbillingham.com> (JBCameraView)
- Markos Charatzas <markos@qnoid.com> (JBCameraView)

## License

MIT licensed - see [LICENSE](LICENSE) file
