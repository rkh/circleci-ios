# -*- coding: utf-8 -*-
$:.unshift('/Library/RubyMotion/lib')
require 'motion/project'
require 'bundler'
require 'motion-cocoapods'

Bundler.require

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'CircleCI'
  app.frameworks += ['UIKit']

  app.pods do
    pod 'SSPullToRefresh'
  end
end
