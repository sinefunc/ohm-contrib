module Ohm
  module LengthValidations

    def assert_min_length(att, length, error = [att, :too_short])
      if assert_present(att, error)
        m = send(att).to_s
        assert is_long_enough?(m, length), error
      end
    end

    def assert_max_length(att, length, error = [att, :too_long])
      if assert_present(att, error)
        m = send(att).to_s
        assert is_too_long?(m, length), error
      end
    end

    private
    def is_too_long?(string, length)
      string.size <= length
    rescue ArgumentError
      return false
    end

    def is_long_enough?(string, length)
      string.size >= length
    rescue ArgumentError
      return false
    end
  end
end
