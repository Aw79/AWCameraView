Pod::Spec.new do |s|
	s.name = 'AWCameraView'
	s.version = '0.6.0'
	s.summary = 'UIView to show the camera, take a picture, preview it, return UIImage'
	s.homepage = 'https://github.com/Aw79/AWCameraView'
	s.license = 'MIT'
	s.author = { 'Andreas Woerner' => 'awoerner@gmx.net', 'James Billingham' => 'james@billingham.net', 'Markos Charatzas' => 'markos@qnoid.com' }

	s.source = { git: 'https://github.com/Aw79/AWCameraView.git', tag: "#{s.version}" }

	s.requires_arc = true
	s.ios.deployment_target = '9.0'

	s.source_files = 'AWCameraView/*.{h,m}'
	s.public_header_files = 'AWCameraView/*.h'

	s.frameworks = 'Foundation', 'UIKit', 'AVFoundation', 'CoreMedia', 'CoreGraphics'
end
