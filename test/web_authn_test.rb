require 'test_helper'

class WebAuthnTest < Minitest::Test
  def test_registration_challenge
    puts Plaintext::WebAuthn.registration_challenge('jerry G')
  end
end
