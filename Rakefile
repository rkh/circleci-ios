# -*- coding: utf-8 -*-
$:.unshift('/Library/RubyMotion/lib')
require 'motion/project'
require 'bundler'
require 'motion-cocoapods'
require 'dotenv'
require 'dotenv/tasks'

Bundler.require
Dotenv.load

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'CircleCI'
  app.frameworks += ['UIKit', 'CoreTelephony', 'QuartzCore', 'SystemConfiguration']
  app.vendor_project('vendor/KiipSDK.framework', :static,
        :products => ['KiipSDK'],
        :headers_dir => 'Headers')
  app.deployment_target = '5.0'
  app.interface_orientations = [:portrait]
  app.pods do
    pod 'SSPullToRefresh'
  end
end
