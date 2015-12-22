require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/just_checkers/*_test.rb']
end

desc 'run tests'
task :default => :test
