2.0.0
=====

* Support for Ohm 1.3.x has been removed. It only supports Ohm 2.x.

1.2
===

* Support for <= 1.1 versions has been removed.Ohm-contrib v1.2 should be used
  with Ohm 1.2 and above only, due to the change in the way the `Ohm::Set` and
  `Ohm::MultiSet` are defined. The way to extend #initialize on both has changed.

1.1.1
=====

* Add Symbol and Set datatypes.

  Example:

    class Foo < Ohm::Model
      include Ohm::DataTypes

      attribute :state, Type::Symbol
      attribute :bar_ids, Type::Set
    end

1.0.0
=====

* `Ohm::Typecast` has been removed in favor of `Ohm::DataTypes`.

* `Ohm::Timestamping` has been renamed to `Ohm::Timestamps`.

* `Ohm::Timestamps` now store times as a UNIX Timestamp.

* `All Ohm validation related plugins have been removed.
  See [scrivener][scrivener] instead.

* `Ohm::Boundaries` has been removed.

* `Ohm::Contrib` no longer uses `autoload`. You can either `require 'ohm/contrib'`,
  which requires everything, or you can `require 'ohm/datatypes'` for example
  if you want to cherry pick your requires.

* `Ohm::Callbacks` no longer provides macro style callbacks, i.e.
  `after :create, :do_something`. Use instance callbacks instead.

[scrivener]: http://github.com/soveran/scrivener
