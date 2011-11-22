task :test do
  require 'cutest'
  $:.unshift('./lib', './test')

  Cutest.run(Dir['./test/*.rb'])
end