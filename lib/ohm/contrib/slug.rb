module Ohm
  module Slug
    def self.included(base)
      base.extend FinderOverride
    end

    module FinderOverride
      def [](id)
        super(id.to_i)
      end
    end

    def slug(str = to_s)
      str.gsub("'", "").gsub(/\p{^Alnum}/u, " ").strip.gsub(/\s+/, "-").downcase
    end
    module_function :slug

    def to_param
      "#{ id }-#{ slug }"
    end
  end
end

