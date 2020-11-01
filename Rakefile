require 'rake/testtask'

task :default => :test

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/*_test.rb']
  t.verbose = false
  t.warning = false
end

desc "Run specific test - Example: rake run_test[p-adic-crypto,test_encrypt_and_decrypt]"
task :run_test, [:test_file,:test_name] do |task, args|
  puts `ruby -Ilib:test test/#{args[:test_file]}_test.rb -n #{args[:test_name]}`
end
