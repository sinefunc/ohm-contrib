module Ohm
  module Contrib
    VERSION = '0.0.20'
  end

  autoload :Boundaries,        "ohm/contrib/boundaries"
  autoload :Timestamping,      "ohm/contrib/timestamping"
  autoload :ToHash,            "ohm/contrib/to_hash"
  autoload :WebValidations,    "ohm/contrib/web_validations"
  autoload :NumberValidations, "ohm/contrib/number_validations"
  autoload :ExtraValidations,  "ohm/contrib/extra_validations"
  autoload :Typecast,          "ohm/contrib/typecast"
  autoload :Locking,           "ohm/contrib/locking"
  autoload :Callbacks,         "ohm/contrib/callbacks"
end
