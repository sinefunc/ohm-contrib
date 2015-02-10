module Ohm
  module Scope
    def self.included(model)
      unless model.const_defined?(:DefinedScopes)
        model.const_set(:DefinedScopes, Module.new)
      end

      model.extend ClassMethods
    end

    module ClassMethods
      def scope(scope = nil, &block)
        self::DefinedScopes.module_eval(&block) if block_given?
        self::DefinedScopes.send(:include, scope) if scope
      end
    end
  end

  # In Ohm v1.2, the Set initialize method is defined on
  # itself. Hence the trick of doing a module OverloadedSet
  # with an initialize method doesn't work anymore.
  #
  # The simplest way to solve that as of now is to duplicate
  # and extend the #initialize method for Ohm::Set.
  #
  # Granted it's not the _ideal_ way, the drawbacks are
  # outweighed by the simplicity and performance of this
  # approach versus other monkey-patching techniques.
  class Set
    def initialize(model, namespace, key)
      @model = model
      @namespace = namespace
      @key = key

      extend model::DefinedScopes if defined?(model::DefinedScopes)
    end
  end
end
