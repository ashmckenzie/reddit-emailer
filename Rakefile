require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs.push 'lib', 'test'
  t.verbose = false
  t.test_files = Dir['test/*/**_spec.rb']
end

task :default => :test