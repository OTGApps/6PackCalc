# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  app.name = '6Pack Calc'
  app.deployment_target = '7.0'
  app.device_family = [:iphone]
  app.interface_orientations = [:portrait, :portrait_upside_down]
  app.identifier = 'com.homebrewparadise.sixpackcalc'
  app.version = '15'
  app.short_version = '2.0.0'
  app.icons = Dir.glob("resources/Icon*.png").map{|icon| icon.split("/").last}
  app.info_plist['FULL_APP_NAME'] = '6Pack Calculator'
  app.info_plist['APP_STORE_ID'] = 414522449
  app.info_plist['UIViewControllerBasedStatusBarAppearance'] = false
  app.info_plist['UIStatusBarStyle'] = 'UIStatusBarStyleLightContent'

  app.pods do
    pod 'FlurrySDK'
    pod 'Appirater'
    pod 'Harpy'
  end

  app.release do
    app.info_plist['AppStoreRelease'] = true
    app.entitlements['get-task-allow'] = false
    app.codesign_certificate = "iPhone Distribution: Mohawk Apps, LLC (DW9QQZR4ZL)"
    app.provisioning_profile = "./provisioning/Distribution.mobileprovision"
  end
end
