platform :ios, 7.0
pod 'MagicalRecord/Shorthand', '2.2'
pod 'GoogleAnalytics-iOS-SDK', '3.0.3'
pod 'Google-Mobile-Ads-SDK', '6.8.0'
pod 'JDStatusBarNotification', '1.4.7'
pod 'CocoaLumberjack', '1.8.1'

pod 'HYUtils', :git => 'https://github.com/hrk-ys/HYUtils.git', :commit => '806679b2773695602825a57ff1d7b8edb4e63bdb'

target :SnippetKeyboard, :exclusive => true do
    pod 'MagicalRecord/Shorthand', '2.2'
end

post_install do | installer |
    require 'fileutils'
    FileUtils.cp_r('Pods/Pods-Acknowledgements.plist', 'SnippetText/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end
