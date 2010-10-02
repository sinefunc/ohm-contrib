module Ohm
  module Scope
    def self.included(base)
      unless defined?(base::DefinedScopes)
        base.const_set(:DefinedScopes, Module.new)
      end

      base.extend Macros
    end

    module Macros
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

    Ohm::Model::Set.send :include, OverloadedSet
  end
end

