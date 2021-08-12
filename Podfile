# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

# ignore all warnings from all pods
inhibit_all_warnings!

target 'WhiteCatShowImage' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Networking
  pod 'Alamofire' # https://github.com/Alamofire/Alamofire

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

  # UI
  pod 'Hero' # https://github.com/HeroTransitions/Hero
  pod 'Spring', :git => 'https://github.com/MengTo/Spring.git' # https://github.com/MengTo/Spring
  pod 'lottie-ios' # https://github.com/airbnb/lottie-ios

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
end
