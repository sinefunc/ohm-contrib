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

    module OverloadedSet
      def initialize(*args)
        super

        extend model::DefinedScopes if defined?(model::DefinedScopes)
      end
    end
  end

  Set.send :include, Scope::OverloadedSet
  MultiSet.send :include, Scope::OverloadedSet
end
