Gem::Specification.new do |s|
  s.name = "ohm-contrib"
  s.version = "1.2"
  s.summary = %{A collection of decoupled drop-in modules for Ohm.}
  s.description = %{Includes a couple of core functions such as callbacks, timestamping, typecasting and lots of generic validation routines.}
  s.author = "Cyril David"
  s.email = "cyx.ucron@gmail.com"
  s.homepage = "http://github.com/cyx/ohm-contrib"

  s.specification_version = 2 if s.respond_to? :specification_version=

  s.files = Dir[
    "LICENSE",
    "README.markdown",
    "rakefile",
    "lib/**/*.rb",
    "*.gemspec",
    "test/*.*",
  ]

  s.require_paths = ["lib"]
  s.rubyforge_project = "ohm-contrib"

  s.add_dependency "ohm", "~> 2.0"

  s.add_development_dependency "cutest"
  s.add_development_dependency "override"
end
