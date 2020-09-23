require 'rake'
require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rspec/core/rake_task'
require 'logger'
require_relative 'test/test_it'
require_relative 'test/helper_test'

desc 'Run test suite'
Rake::TestTask.new do |t|
  Finix::FinixTest.logger = Logger.new STDOUT
  Finix::FinixTest.logger.level = Logger::ERROR
  t.pattern ='test/**/test_*.rb'
end

desc 'Run rspec suite'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = Dir.glob('spec/**/*_spec.rb')
end

task testit: [:test, :spec]