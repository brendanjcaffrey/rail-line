# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  app.name = 'Rail Line'
  app.identifier = 'com.jcaffrey.railline'
  app.seed_id = 'JD9296YG3D'
  app.icons = ['Icon-60@2x.png', 'Icon-60@3x.png']
  app.provisioning_profile = './railline.mobileprovision'

  app.frameworks += ['SafariServices', 'MapKit', 'QuartzCore', 'CoreImage', 'CoreGraphics']
  app.fonts += ['ionicons.ttf']

  app.vendor_project('vendor/ZSPinAnnotation', :static)

  # allow the app to load http:// for the CTA API
  app.info_plist['NSAppTransportSecurity'] = { 'NSAllowsArbitraryLoads' => true }
  app.info_plist['NSLocationWhenInUseUsageDescription'] = 'To show your location relative to stations.'
end
