require 'test_helper'

class RegistrationTest < Minitest::Test
  def test_registration
    alpha, pub_u, priv_u = Plaintext::Registration.client_start('barry')

    puts "#{alpha}-#{pub_u}-#{priv_u}"

    beta, v, pub_s = Plaintext::Registration.start('barry', alpha)

    envelope = Plaintext::Registration.client_finalize(
      'barry', beta, v, pub_u, pub_s, priv_u
    )

    puts envelope
  end
end
