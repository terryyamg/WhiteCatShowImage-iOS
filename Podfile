# Uncomment the next line to define a global platform for your project
 platform :ios, '13.0'

# ignore all warnings from all pods
inhibit_all_warnings!

target 'WhiteCatShowImage' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Networking

  # Rx
  pod 'RxSwift', '~> 5' # https://github.com/ReactiveX/RxSwift
  pod 'RxCocoa', '~> 5'
  
  # Auto Layout
  pod 'SnapKit' # https://github.com/SnapKit/SnapKit

  # Image
  pod 'Kingfisher' # https://github.com/onevcat/Kingfisher
  pod 'FSPagerView' # https://github.com/WenchaoD/FSPagerView
  
  # Tools
  pod 'R.swift' # https://github.com/mac-cain13/R.swift
  pod 'SwiftLint' # https://github.com/realm/SwiftLint
  pod 'SwiftSoup' # https://github.com/scinfu/SwiftSoup

  # UI
  pod 'LTMorphingLabel' # https://github.com/lexrus/LTMorphingLabel
  pod 'lottie-ios' # https://github.com/airbnb/lottie-ios
  pod 'SideMenu', '~> 6.0' # https://github.com/jonkykong/SideMenu

  # Keyboard
  pod 'IQKeyboardManagerSwift'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.name == 'Hero'
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '5.0'
      end
    end
  end
  installer.generated_projects.each do |project|
      project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
          end
      end
  end
end
