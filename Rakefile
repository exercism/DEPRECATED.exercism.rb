require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new(name=:test) do |t|
  t.pattern = "{test/exercism/*_test.rb,test/*_test.rb}"
end
 
Rake::TestTask.new(name=:env_dependent) do |t|
  t.pattern = "{test/exercism/*_test_env_dependent.rb,
                test/exercism/*_test.rb,
                test/*_test.rb}"
end

task :default => :test

