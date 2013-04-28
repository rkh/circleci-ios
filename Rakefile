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
  app.identifier = ENV['APP_ID']
  app.frameworks += ['UIKit']
  app.deployment_target      = '5.0'
  app.interface_orientations = [:portrait]
  app.prerendered_icon       = true
  app.pods do
    pod 'SSPullToRefresh'
    pod 'MD5Digest'
  end

  app.development do
    app.codesign_certificate = ENV['CODE_CERT']
    app.provisioning_profile = ENV['DEV_PROV_PROF']
  end

  app.release do
    app.seed_id              = ENV['SEED_ID']
    app.codesign_certificate = ENV['RELEASE_CODE_CERT']
    app.provisioning_profile = ENV['RELEASE_PROV_PROF']
  end
end
