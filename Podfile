# Uncomment the next line to define a global platform for your project
# platform :ios, '11.0'
workspace 'GhostNight'
platform :ios, '12.0'
inhibit_all_warnings!

def firebase_sdk
  # FireBase
  pod 'GoogleAnalytics'
  pod 'Firebase'
  pod 'Firebase/Messaging'
  pod 'Firebase/Core'
  pod 'Firebase/Database'
  pod 'Firebase/RemoteConfig'
  pod 'Firebase/DynamicLinks'
  pod 'Firebase/Storage'
end

def facebook_sdk
  # Facebook
  pod 'FacebookCore', '0.9.0'
  pod 'FacebookLogin'
  pod 'FacebookShare'
  pod 'AccountKit'
end

def share_pod
  pod 'IQKeyboardManagerSwift', '6.5.2'
  pod 'AlamofireObjectMapper', '5.2.1'
  pod 'SDWebImage', '5.2.5'
  pod 'FTIndicator', '1.2.9'
  pod 'Reusable', '4.1.0'
  #Rx
  pod 'RxSwift', '4.5.0'
  pod 'RxSwiftExt', '3.4.0'
  #RxExtension
  pod 'Moya/RxSwift'
  
  #UI
  pod 'MarqueeLabel', '4.0.0'
  
  #Transition
  pod 'SPStorkController', '1.7.9'
  pod 'SPFakeBar', '1.0.9'
  
  pod 'SnapKit', '4.2.0'
  
  pod 'SwiftDate', '5.1.0'
end

def ads_sdk
  # Ads Mob
  pod 'Google-Mobile-Ads-SDK'
end


target 'Ghost Night' do
  project 'GhostNight.xcodeproj'
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  # Facebook
  facebook_sdk
  # Ads Mob
  ads_sdk
  # FireBase
  firebase_sdk
  # Share Pod
  share_pod
  # Pods for Ghost Night

  target 'Ghost NightTests' do
    inherit! :search_paths
    # Pods for testing
  end

end

# ===============================================
# Start - Player ============
# ===============================================
#
target 'GhostNightPlayer' do
  project 'FeatureModular/GhostNightPlayer/GhostNightPlayer'
  use_frameworks!
  share_pod
  ads_sdk
end

# ===============================================
# Start - Data Layer ============
# ===============================================
#
target 'Component' do
  project 'Share/Component/Component'
  use_frameworks!
  share_pod
  facebook_sdk
end

target 'Data' do
  project 'Share/Data/Data'
  use_frameworks!
  share_pod
end

# ===============================================
# Start - Core Layer ============
# ===============================================
#
target 'Core' do
  project 'Core/Core/Core'
  use_frameworks!
  share_pod
end

