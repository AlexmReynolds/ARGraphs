Pod::Spec.new do |s|
  s.name         = "ARGraphs"
  s.version      = "0.0.6"
  s.summary      = "Awesome HealthKit style iOS Charts"

  s.description  = <<-DESC
                   Custom iOS charts styled after HealthKit's charts.
                   DESC

  s.homepage     = "https://github.com/AlexmReynolds/ARGraphs"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  s.license      = { :type => "MIT", :file => "License" }

  s.author       = { "Alex Reynolds" => "alex.micheal.reynolds@gmail.com" }

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/AlexmReynolds/ARGraphs.git", :tag => "0.0.6" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any h, m, mm, c & cpp files. For header
  #  files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  s.source_files  = "ARGraphs/*.{h,m}", "ARGraphs/Private/*.{h,m}"
  s.public_header_files = "ARGraphs/*.h"

  s.requires_arc = true

end