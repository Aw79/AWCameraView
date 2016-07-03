# `AWCameraView` [![Build Status](https://travis-ci.org/Aw79/AWCameraView.svg?branch=master)](https://travis-ci.org/Aw79/AWCameraView)
(fork of JBCameraView)

UIView to show the camera, take a picture, preview it, return UIImage.

Even though an `UIImagePickerController` allows a custom overlay to override the
default camera controls, it gives you no control over its camera bounds. Instead
it captures a UIImage in full camera resolution, giving you the option to edit
as a second step.

Note: as of v0.3.0, you must specify the camera position before the camera will
activate.

## Installation

```ruby
pod 'AWCameraView'
```

## Usage

### Interface Builder

* Drag a UIView into the interface and set its type to `AWCameraView`
* Set its delegate to a class that implements `AWCameraViewDelegate`
* Set the preferred camera position (will failover to the other one)
* Call `takePicture` on `AWCameraView` to receive the UIImage on your delegate
* Enable focus and exposure by setting `enableFocusOnTap`on ÀWCameraView` or
* Call `focusOnPoint` on `AWCameraView` to focus on the given position


### Code

```objc
AWCameraView *cameraView = [[AWCameraView alloc] initWithFrame:CGRect(320, 320)];
cameraView.delegate = self;
cameraView.position = AWCameraViewPositionBack;

[cameraView takePicture];
```

## Support

Please open an issue on this repository.

## Authors

- Andreas Woerner <awoerner@gmx.net>
- James Billingham <james@jamesbillingham.com> (JBCameraView)
- Markos Charatzas <markos@qnoid.com> (JBCameraView)

## License

MIT licensed - see [LICENSE](LICENSE) file
