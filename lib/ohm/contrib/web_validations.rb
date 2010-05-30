module Ohm
  # All credit goes to gnrfan of github
  # Basically an extraction from http://github.com/gnrfan/ohm_extra_validations
  #
  # * 2010-05-29 Updated Email Regex, Extracted out regexs to constants
  #
  # This module provides the following:
  # * assert_slug
  # * assert_email
  # * assert_url
  # * assert_ipv4
  module WebValidations
    # @see http://fightingforalostcause.net/misc/2006/compare-email-regex.php
    EMAIL_REGEX = /^([\w\!\#$\%\&\'\*\+\-\/\=\?\^\`{\|\}\~]+\.)*[\w\!\#$\%\&\'\*\+\-\/\=\?\^\`{\|\}\~]+@((((([a-z0-9]{1}[a-z0-9\-]{0,62}[a-z0-9]{1})|[a-z])\.)+[a-z]{2,6})|(\d{1,3}\.){3}\d{1,3}(\:\d{1,5})?)$/i

    SLUG_REGEX  = /^[-\w]+$/

    URL_REGEX   = /^(http|https):\/\/([a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}|(25[0-5]|2[0-4]\d|[0-1]?\d?\d)(\.(25[0-5]|2[0-4]\d|[0-1]?\d?\d)){3}|localhost)(:[0-9]{1,5})?(\/.*)?$/ix

    IPV4_REGEX  = /^(25[0-5]|2[0-4]\d|[0-1]?\d?\d)(\.(25[0-5]|2[0-4]\d|[0-1]?\d?\d)){3}$/

  protected
    def assert_slug(att, error = [att, :not_slug])
      if assert_present(att, error) and assert_unique(att)
        assert_format(att, SLUG_REGEX, error)
      end
    end

    def assert_email(att, error = [att, :not_email])
      if assert_present(att, error)
        assert_format(att, EMAIL_REGEX, error)
      end
    end

    def assert_url(att, error = [att, :not_url])
      if assert_present(att, error)
        assert_format(att, URL_REGEX, error)
      end
    end

    def assert_ipv4(att, error = [att, :not_ipv4])
      if assert_present(att, error)
        assert_format(att, IPV4_REGEX, error)
      end
    end

    def assert_ipaddr(att, error = [att, :not_ipaddr])
      assert_ipv4(att, error)
    end
  end
end