# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'reloc/version'

Gem::Specification.new do |gem|
  gem.name          = "reloc"
  gem.version       = Reloc::VERSION
  gem.authors       = ["Dave Kinkead"]
  gem.email         = ["dave@kinkead.com.au"]
  gem.description   = %q{Create easy to read, hard to guess, domain specific unique IDs}
  gem.summary       = %q{A super simple way to generate easy to read, hard to guess, domain specific unique IDs.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|specs|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'rake'
end
