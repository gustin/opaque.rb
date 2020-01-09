require 'test_helper'

class AuthenticatorTest < Minitest::Test
  def test_generating_qr_code
    puts '~)- Ruby Land ~)-'
    puts Plaintext::Authenticator.generate_second_factor('user 12')
  end

  def test_second_factor_confirmation
    puts Plaintext::Authenticator.confirm_second_factor('123456')
  end
end
