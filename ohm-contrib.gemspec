Gem::Specification.new do |s|
  s.name = "ohm-contrib"
  s.version = "2.0.1"
  s.summary = %{A collection of decoupled drop-in modules for Ohm.}
  s.description = %{Includes a couple of core functions such as callbacks, timestamping, typecasting and lots of generic validation routines.}
  s.author = "Cyril David"
  s.email = "cyx@cyx.is"
  s.homepage = "http://github.com/cyx/ohm-contrib"
  s.license = "MIT"

  s.files = `git ls-files`.split("\n")

  s.add_dependency "ohm", "~> 2.0.0"

  s.add_development_dependency "cutest"
  s.add_development_dependency "iconv"
  s.add_development_dependency "override"
end
