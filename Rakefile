require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

# rubocop:disable Style/HashSyntax

task :validate_gemspec do
  Bundler.load_gemspec('consenter.gemspec').validate
end

task :version => :validate_gemspec do
  puts Consenter::VERSION
end

task :default => :test

# rubocop:enable Style/HashSyntax
