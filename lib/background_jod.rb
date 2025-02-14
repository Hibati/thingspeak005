#!/usr/bin/env ruby
# -*- ruby -*-
require 'rubygems'
require 'daemon_spawn'

RAILS_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))

class DelayedJobWorker < DaemonSpawn::Base
  
  def start(args)
    ENV['RAILS_ENV'] ||= args.first || 'development'
    require File.join(RAILS_ROOT, 'config', 'environment')
    
    Delayed::Worker.new.start
  end
  
  def stop
    system("kill `cat #{RAILS_ROOT}/tmp/pids/delayed_job.pid`")
  end
end

DelayedJobWorker.spawn!(:log_file => File.join(RAILS_ROOT, "log", "delayed_job.log"),
:pid_file => File.join(RAILS_ROOT, 'tmp', 'pids', 'delayed_job.pid'),
:sync_log => true,
:working_dir => RAILS_ROOT)