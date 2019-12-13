require 'test_helper'

class PlaintextTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Plaintext::VERSION
  end

  def test_registration
    puts '~) OPAQUE Via Ruby ~)'
    alpha = [174, 17, 253, 238, 61, 54, 246, 96, 134, 222, 69, 115, 52, 224, 182, 129, 135, 201, 31, 217, 76, 37, 186, 203, 89, 193, 216, 214, 86, 253, 86, 64]
    Plaintext::RegistrationMe.registration('larry', alpha)
  end

  def test_generating_totp
    skip('Not doing it..')
    puts '~)- Ruby Land ~)-'
    puts Plaintext::AuthN.generate_qr('user 12')
  end
end
