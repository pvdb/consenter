lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'consenter/version'

Gem::Specification.new do |spec|
  spec.name          = Consenter::NAME
  spec.version       = Consenter::VERSION
  spec.authors       = ['Peter Vandenberk']
  spec.email         = ['pvandenberk@mac.com']

  spec.summary       = 'Idiomatic Enumerable extension to filter by consent'
  spec.description   = 'Ask for consent for each element in an Enumerable'
  spec.homepage      = 'https://github.com/pvdb/consenter'
  spec.license       = 'MIT'

  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`
      .split("\x0")
      .reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-rescue'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'
end
