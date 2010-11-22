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
      ret = iconv(str)
      ret.gsub!("'", "")
      ret.gsub!(/\p{^Alnum}/u, " ")
      ret.strip!
      ret.gsub!(/\s+/, "-")
      ret.downcase
    end
    module_function :slug

    def iconv(str)
      begin
        require "iconv"

        Iconv.iconv("ascii//translit//ignore", "utf-8", str)[0]
      rescue LoadError
        return str
      end
    end
    module_function :iconv

    def to_param
      "#{ id }-#{ slug }"
    end
  end
end