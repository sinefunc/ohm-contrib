require 'cutest'

task :test do
  $:.unshift('./lib', './test')

  Cutest.run(Dir['./test/*_test.rb'])
end

