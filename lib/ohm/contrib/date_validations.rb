require 'date'

module Ohm
  module DateValidations
    DATE_REGEX = /\A([0-9]{4})-([01]?[0-9])-([0123]?[0-9])\z/
    
    def assert_date(att, error = [att, :not_date])
      if assert_format att, DATE_REGEX, error
        m = send(att).to_s.match(DATE_REGEX)
        assert is_date_parseable?(m[1], m[2], m[3]), error
      end
    end

  private
    def is_date_parseable?(year, month, day)
      Date.new(Integer(year), Integer(month), Integer(day))
    rescue ArgumentError
      return false
    else
      return true
    end
  end
end
