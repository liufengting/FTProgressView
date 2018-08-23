#
#  Be sure to run `pod spec lint FTImageViewController.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
	
  s.name         = "FTProgressView_FT"
  s.version      = "0.0.1"
  s.summary      = "FTProgressView is a subclass of UIView, which shows circle progress or pie progress."
  s.description  = <<-DESC
  FTProgressView is a subclass of UIView, which shows circle progress or pie progress. Feel free to run the demo and use it in your own projects.
                   DESC
  s.homepage     = "https://github.com/liufengting/FTProgressView"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "liufengting" => "wo157121900@me.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/liufengting/FTProgressView.git", :tag => "#{s.version}" }
  s.source_files  = "FTProgressView", "FTProgressView/*.{h,m,swift}"
  s.swift_version = '4.0'

end
