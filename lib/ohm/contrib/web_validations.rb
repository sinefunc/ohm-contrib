module Ohm
  # All credit goes to gnrfan of github
  # Basically an extraction from http://github.com/gnrfan/ohm_extra_validations
  module WebValidations

  protected
    def assert_slug(att, error = [att, :not_slug])
      if assert_present(att, error) and assert_unique(att)
          assert_format(att, /^[-\w]+$/, error)
      end
    end

    def assert_email(att, error = [att, :not_email])
      if assert_present(att, error)
        assert_format(att, /^([^@\s*]+)@((?:[-a-z0-9]+\.)+[a-z]{2,6})$/i, error)
      end
    end

    def assert_url(att, error = [att, :not_url])
      if assert_present(att, error)
        assert_format(att, /^(http|https):\/\/([a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}|(25[0-5]|2[0-4]\d|[0-1]?\d?\d)(\.(25[0-5]|2[0-4]\d|[0-1]?\d?\d)){3}|localhost)(:[0-9]{1,5})?(\/.*)?$/ix, error)
      end
    end

    def assert_ipv4(att, error = [att, :not_ipv4])
      if assert_present(att, error)
        assert_format(att, /^(25[0-5]|2[0-4]\d|[0-1]?\d?\d)(\.(25[0-5]|2[0-4]\d|[0-1]?\d?\d)){3}$/, error)
      end
    end

    def assert_ipaddr(att, error = [att, :not_ipaddr])
        assert_ipv4(att, error)
    end
  end
end