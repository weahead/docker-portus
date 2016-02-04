#!/usr/bin/env puma

threads 1, 4
workers 3
bind 'tcp://0.0.0.0:3000'

preload_app!

environment 'production'

on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end
