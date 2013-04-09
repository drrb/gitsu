lib_path = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift lib_path unless $LOAD_PATH.include? lib_path
require 'gitsu'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'cucumber/rake/task'
require 'coveralls/rake/task'

Coveralls::RakeTask.new
Cucumber::Rake::Task.new(:features)
RSpec::Core::RakeTask.new(:spec)

task :default => [:spec, :features, 'coveralls:push']

task :verify do
    system "rvm all do rake"
end

task :push_release => :verify do
    git = GitSu::Git.new(GitSu::Shell.new)

    unless git.list_files(:modified).empty?
        abort("Changes in working directory: not releasing")
    end

    version = GitSu::Version.prompt($stdin, $stdout, "Enter the version to release", GitSu::Version.current)
    next_version = GitSu::Version.prompt($stdin, $stdout, "Enter the next development version", version.next_minor)

    puts "Releasing #{version} and preparing for #{next_version}"

    update_version(version)
    git.commit("lib/gitsu/version.rb", "Preparing for release #{version}")
    Rake::Task[:release].invoke
    update_version(next_version)
    git.commit("lib/gitsu/version.rb", "Preparing for next development iteration")
end

def update_version(new_version)
    system(%q[sed -i '' -E 's/VERSION = ".*"/VERSION = "] + new_version.to_s + %q["/' lib/gitsu/version.rb])
end
