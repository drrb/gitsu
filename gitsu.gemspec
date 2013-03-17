# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gitsu/version'

Gem::Specification.new do |gem|
  gem.name          = "gitsu"
  gem.version       = GitSu::VERSION
  gem.authors       = ["drrb"]
  gem.email         = ["drrb@github.com"]
  gem.description   = %q{Manage your Git users}
  gem.summary       = %q{Gitsu allows you to quickly configure and switch between Git users}
  gem.homepage      = "http://drrb.github.com/gitsu"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  # Dependencies
  gem.add_development_dependency('rspec')
  gem.add_development_dependency('cucumber')
end
