# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gitsu/version'

Gem::Specification.new do |gem|
  gem.name          = "gitsu"
  gem.version       = GitSu::VERSION
  gem.authors       = ["drrb"]
  gem.email         = ["drrrrrrrrrrrb@gmail.com"]
  gem.license       = "GPL-3"
  gem.description   = %q{Manage your Git users}
  gem.summary       = <<-EOF
    Gitsu allows you to quickly configure and switch between Git users, for
    different projects and contexts
  EOF
  gem.homepage      = "http://drrb.github.io/gitsu"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  # Dependencies
  gem.add_development_dependency('coveralls', '>= 0.6.3')
  gem.add_development_dependency('json') # Coveralls needs it
  gem.add_development_dependency('rake')
  gem.add_development_dependency('rspec')
  gem.add_development_dependency('cucumber')
end
