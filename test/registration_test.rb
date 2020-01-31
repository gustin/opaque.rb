require 'test_helper'

class RegistrationTest < Minitest::Test
  def test_registration
    alpha, pub_u, priv_u = Plaintext::Registration.client_start('barry')

    puts "#{alpha}-#{pub_u}-#{priv_u}"
  end
end
