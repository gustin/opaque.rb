require 'test_helper'

class PlaintextTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Plaintext::VERSION
  end

  def test_registration
    puts '~) OPAQUE Via Ruby ~)'
    Plaintext::RegistrationMe.registration('larry', [0, 0, 0, 0, 0, 0, 0])
  end

  def test_generating_totp
    skip('Not doing it..')
    puts '~)- Ruby Land ~)-'
    puts Plaintext::AuthN.generate_qr('user 12')
  end
end
