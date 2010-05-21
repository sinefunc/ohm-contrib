module Ohm
  module ExtraValidations
    include NumberValidations
    include WebValidations

  protected
    def assert_member(att, set, error = [att, :not_member])
      assert set.include?(send(att)), error
    end    
  end
end
