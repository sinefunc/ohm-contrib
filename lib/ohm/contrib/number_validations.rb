module Ohm
  # This module will include all numeric validation needs.
  # As of VERSION 0.0.15, Ohm::NumberValidations#assert_decimal
  # is the only method provided.
  module NumberValidations

  protected
    def assert_decimal(att, error = [att, :not_decimal])
      assert_format(att, /^(\d+)?(\.\d+)?$/, error)
    end
  end
end
