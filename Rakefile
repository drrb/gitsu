require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'cucumber/rake/task'

Cucumber::Rake::Task.new(:features)
RSpec::Core::RakeTask.new(:spec)

task :default => [:spec, :features]

