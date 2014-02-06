# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mypage_tools/version'

Gem::Specification.new do |spec|
  spec.name          = "mypage_tools"
  spec.version       = MypageTools::VERSION
  spec.authors       = ["Brown Mike"]
  spec.email         = ["thebrownmike@me.com"]
  spec.description   = %q{myPage tools for Apple Retail employees}
  spec.summary       = %q{myPage tools for Apple Retail employees}
  spec.homepage      = "https://www.github.com/brownmike/mypage_tools"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "capybara", "~> 2.2.1"
  spec.add_runtime_dependency "poltergeist", "~> 1.5.0"
  spec.add_runtime_dependency "icalendar", "~> 1.5.0"
  spec.add_runtime_dependency "active_support", "~> 3.0.0"
  spec.add_runtime_dependency "i18n"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
