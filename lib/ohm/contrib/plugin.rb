module Ohm
  module Plugin
    class Unknown < StandardError
      def initialize(plugin)
        @plugin = plugin
      end

      def message
        "Unknown plugin: #{@plugin}"
      end
    end

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
        raise Unknown.new(plugin) if not Plugin.registry[plugin]

        require Plugin.registry[plugin]
        Ohm.const_get(plugin)
      else
        raise Unknown.new(plugin)
      end
    end
  
    def self.register(name, path)
      registry[name] = path
    end
  
    def self.registry
      @registry ||= {
        :DataTypes            => "ohm/contrib/data_types",
        :Timestamping         => "ohm/contrib/timestamping",
        :Typecast             => "ohm/contrib/typecast",
        :Locking              => "ohm/contrib/locking",
        :Callbacks            => "ohm/contrib/callbacks",
        :Slug                 => "ohm/contrib/slug",
        :Scope                => "ohm/contrib/scope",
        :SoftDelete           => "ohm/contrib/soft_delete"
      }
    end
  end
end
