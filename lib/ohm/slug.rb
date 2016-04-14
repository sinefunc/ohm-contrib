module Ohm
  module Slug
    def self.included(model)
      model.extend ClassMethods
    end

    module ClassMethods
      def [](id)
        super(id.to_i)
      end
    end

    def slug(str = to_s)
      ret = transcode(str.dup)
      ret.gsub!("'", "")
      ret.gsub!(/[^0-9A-Za-z]/u, " ")
      ret.strip!
      ret.gsub!(/\s+/, "-")
      ret.downcase!
      return ret
    end
    module_function :slug

    def transcode(str)
      begin
        # TODO: replace with a String#encode version which will
        # contain proper transliteration tables. For now, Iconv
        # still wins because we get that for free.
        v, $VERBOSE = $VERBOSE, nil
        require "iconv"
        $VERBOSE = v

        Iconv.iconv("ascii//translit//ignore", "utf-8", str)[0]
      rescue LoadError
        return str
      end
    end
    module_function :transcode

    def to_param
      "#{ id }-#{ slug }"
    end
  end
end
