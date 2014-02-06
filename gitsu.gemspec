# -*- encoding: utf-8 -*-
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

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gitsu/version'

Gem::Specification.new do |gem|
  gem.name          = "gitsu"
  gem.version       = GitSu::VERSION
  gem.authors       = ["drrb"]
  gem.email         = ["drrrrrrrrrrrb@gmail.com"]
  gem.license       = "GPL-3"
  gem.description   = %q{User management and pairing for Git}
  gem.summary       = <<-EOF
    Gitsu allows you to quickly configure and switch between Git users, for
    different projects and contexts, and pairing.
  EOF
  gem.homepage      = "http://drrb.github.io/gitsu"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  # Dependencies
  gem.add_development_dependency 'bundler', '~> 1.3'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'coveralls', '>= 0.6.3'
  gem.add_development_dependency 'json' # Coveralls needs it
  gem.add_development_dependency "mime-types", "< 2"
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'cucumber'
end
