require 'rubygems'
require 'rspec/core/rake_task'
task :default => :spec

desc "Spec"
task :spec do
  RSpec::Core::RakeTask.new do |t|
    t.rspec_opts = %w(-fs --color)
  end
end
