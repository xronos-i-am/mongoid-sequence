# encoding: utf-8

# -*- encoding: utf-8 -*-
require File.expand_path('../lib/mongoid-sequence/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Geoffroy Planquart", "Gonçalo Silva"]
  gem.email         = ["geoffroy@planquart.fr", "goncalossilva@gmail.com"]
  gem.description   = %q{Mongoid::Sequence gives you the ability to specify fields to behave like a sequence number (exactly like the "id" column in conventional SQL flavors).}
  gem.summary       = %q{Specify fields to behave like a sequence number (exactly like the "id" column in conventional SQL flavors).}
  gem.homepage      = "https://github.com/CreaLettres/mongoid-sequence"

  gem.add_dependency("moped", ">= 1.5.1", "< 3.0.0")
  gem.add_dependency("mongoid", ">= 4.0.0", "< 5.0.0")
  gem.add_dependency("activesupport", ">= 3.1")
  gem.add_development_dependency("rake", ">= 0.9")

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "mongoid-sequence"
  gem.require_paths = ["lib"]
  gem.version       = Mongoid::Sequence::VERSION
end
