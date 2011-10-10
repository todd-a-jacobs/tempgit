begin
  require 'bundler/gem_tasks'
  require 'bundler/setup'
rescue LoadError => bundler_missing
  $stderr.puts bundler_missing
end

require 'rake'
require 'rspec/core/rake_task'

desc 'Update exuberant-ctags'
task :etags do
  sh %{etags -R}
end

RSpec::Core::RakeTask.new(:spec)
task :default => :spec
