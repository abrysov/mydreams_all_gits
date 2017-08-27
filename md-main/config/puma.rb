#!/usr/bin/env puma

environment ENV['RAILS_ENV'] || 'development'
quiet
threads Integer(ENV['PUMA_MIN_THREADS'] || 1), Integer(ENV['PUMA_MAX_THREADS'] || 16)
workers Integer(ENV['PUMA_WORKERS'] || 1)
bind "tcp://#{ENV['PUMA_HOST'] || '127.0.0.1'}:#{ENV['PUMA_PORT'] || 3000}"

on_worker_boot do
  ActiveRecord::Base.establish_connection
end

preload_app!
Thread.abort_on_exception = true

tag 'Dreams'

# activate_control_app 'unix:///var/run/pumactl.sock', { no_token: true }
