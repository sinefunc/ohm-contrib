module Ohm
  # This module will include all numeric validation needs.
  # As of VERSION 0.0.27, Ohm::NumberValidations#assert_decimal
  # is the only method provided.
  module NumberValidations
    DECIMAL_REGEX = /^(\d+)?(\.\d+)?$/

  protected
    def assert_decimal(att, error = [att, :not_decimal])
      assert_format att, DECIMAL_REGEX, error
    end
  end
end
