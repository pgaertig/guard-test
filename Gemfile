source "http://rubygems.org"

# Specify your gem's dependencies in guard-test.gemspec
gemspec

gem 'rake'
gem 'guard-rspec', :github => "guard/guard-rspec", :branch => "guard_1_1"

require 'rbconfig'

platforms :ruby do
  gem 'rb-readline'

  if RbConfig::CONFIG['target_os'] =~ /darwin/i
    gem 'rb-fsevent'
    gem 'ruby_gntp'
  elsif RbConfig::CONFIG['target_os'] =~ /linux/i
    gem 'rb-inotify'
    gem 'libnotify'
  end
end

platforms :jruby do
  if RbConfig::CONFIG['target_os'] =~ /darwin/i
    gem 'ruby_gntp'
  elsif RbConfig::CONFIG['target_os'] =~ /linux/i
    gem 'rb-inotify'
    gem 'libnotify'
  end
end
