
Gem::Specification.new do |s|
  s.name = 'ohm-contrib'
  s.version = "0.0.36"
  s.summary = %{A collection of decoupled drop-in modules for Ohm}
  s.date = %q{2010-05-12}
  s.author = "Cyril David"
  s.email = "cyx.ucron@gmail.com"
  s.homepage = "http://github.com/cyx/ohm-contrib"

  s.specification_version = 2 if s.respond_to? :specification_version=

  s.files = ["lib/ohm/contrib/boundaries.rb", "lib/ohm/contrib/callbacks.rb", "lib/ohm/contrib/date_validations.rb", "lib/ohm/contrib/extra_validations.rb", "lib/ohm/contrib/length_validations.rb", "lib/ohm/contrib/locking.rb", "lib/ohm/contrib/lunar_macros.rb", "lib/ohm/contrib/number_validations.rb", "lib/ohm/contrib/scope.rb", "lib/ohm/contrib/slug.rb", "lib/ohm/contrib/timestamping.rb", "lib/ohm/contrib/typecast.rb", "lib/ohm/contrib/web_validations.rb", "lib/ohm/contrib.rb", "README.markdown", "LICENSE", "Rakefile", "test/autoload_test.rb", "test/boundaries_test.rb", "test/callbacks_lint.rb", "test/date_validations_test.rb", "test/helper.rb", "test/instance_callbacks_test.rb", "test/length_validations_test.rb", "test/lunar_macros_test.rb", "test/macro_callbacks_test.rb", "test/membership_validation_test.rb", "test/number_validations_test.rb", "test/scope_test.rb", "test/slug_test.rb", "test/timestamping_test.rb", "test/typecast_array_test.rb", "test/typecast_boolean_test.rb", "test/typecast_date_test.rb", "test/typecast_decimal_test.rb", "test/typecast_float_test.rb", "test/typecast_hash_test.rb", "test/typecast_integer_test.rb", "test/typecast_string_test.rb", "test/typecast_time_test.rb", "test/typecast_timezone_test.rb", "test/web_validations_test.rb"]

  s.require_paths = ['lib']

  s.rubyforge_project = "ohm-contrib"

  s.has_rdoc = false
  s.add_dependency "ohm"

  s.add_development_dependency "cutest"
  s.add_development_dependency "redis"
  s.add_development_dependency "lunar"
  s.add_development_dependency "override"
end

