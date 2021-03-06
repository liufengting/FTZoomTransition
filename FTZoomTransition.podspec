
Pod::Spec.new do |s|

  s.name         = "FTZoomTransition"
  s.version      = "0.2.2"
  s.summary      = "Customize the present animation"
  s.description  = <<-DESC
    	FTZoomTransition. Customize the present animation with simple api.
                   DESC
  s.homepage     = "https://github.com/liufengting/FTZoomTransition"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author		 = { "liufengting" => "wo157121900@me.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/liufengting/FTZoomTransition.git", :tag => "#{s.version}" }
  s.source_files = ["FTZoomTransition/*.swift"]
  s.framework    = "UIKit"
  s.swift_version = '5.0'

end
