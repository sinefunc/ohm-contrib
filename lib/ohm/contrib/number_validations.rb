module Ohm
  module NumberValidations

  protected
    def assert_decimal(att, error = [att, :not_decimal])
      assert_format(att, /^(\d+)?(\.\d+)?$/, error)
    end
  end
end