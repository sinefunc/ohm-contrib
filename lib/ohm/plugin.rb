module Ohm
  module Plugin
    def plugin(name)
      mixin = Plugin[name]

      include mixin
      extend  mixin::ClassMethods if mixin.const_defined?(:ClassMethods, false)

      mixin.setup(self) if mixin.respond_to?(:setup)
    end

    def self.[](plugin)
      case plugin
      when Module
        plugin
      when Symbol
        name, path = Plugin.registry[plugin]

        raise Unknown.new(plugin) if name.nil?

        require path
        Ohm.const_get(name, false)
      else
        raise Unknown.new(plugin)
      end
    end

    def self.register(name, name_and_path)
      registry[name] = name_and_path
    end

    def self.registry
      @registry ||= {
        :callbacks     => [:Callbacks,    "ohm/contrib/callbacks"],
        :datatypes     => [:DataTypes,    "ohm/contrib/data_types"],
        :locking       => [:Locking,      "ohm/contrib/locking"],
        :scope         => [:Scope,        "ohm/contrib/scope"],
        :slug          => [:Slug,         "ohm/contrib/slug"],
        :softdelete    => [:SoftDelete,   "ohm/contrib/soft_delete"],
        :timestamping  => [:Timestamping, "ohm/contrib/timestamping"]
      }
    end

    class Unknown < StandardError
      def initialize(plugin)
        @plugin = plugin
      end

      def message
        "Unknown plugin: #{@plugin}"
      end
    end
  end
end