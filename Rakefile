# Gitsu
# Copyright (C) 2013 drrb
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

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

task 'push-release' => ['check-license', :verify] do
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

task 'check-license' do
    puts "Checking that all program files contain license headers"
    
    files = `git ls-files`.split "\n"
    ignored_files = File.read(".licenseignore").split("\n") << ".licenseignore"
    offending_files = files.reject { |file| File.read(file).include? "WITHOUT ANY WARRANTY" } - ignored_files
    unless offending_files.empty?
        abort("ERROR: THE FOLLOWING FILES HAVE NO LICENSE HEADERS: \n" + offending_files.join("\n"))
    end
end

def update_version(new_version)
    system(%q[sed -i '' -E 's/VERSION = ".*"/VERSION = "] + new_version.to_s + %q["/' lib/gitsu/version.rb])
end
