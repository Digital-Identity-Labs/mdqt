require 'rubygems'
require 'cucumber'
require 'cucumber/rake/task'

desc "Run Cucumber tests"
Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty"
end