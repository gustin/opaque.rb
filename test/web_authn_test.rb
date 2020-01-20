require 'json'
require 'test_helper'

class WebAuthnTest < Minitest::Test
  def test_registration_challenge
    puts Plaintext::WebAuthn.registration_challenge('Jerry G')
  end

  def test_register_credential
    credential = '{"id":"Gss9igxU-3iZffReo4citavDk5c6l9YQcsFAK8OPbBTFfTah3sApRZerYS48GzcN","type":"public-key","rawId":"W29iamVjdCBBcnJheUJ1ZmZlcl0=","response":{"clientDataJSON":"W29iamVjdCBBcnJheUJ1ZmZlcl0=","attestationObject":"W29iamVjdCBBcnJheUJ1ZmZlcl0="}}'

    puts Plaintext::WebAuthn.register_credential('Jerry G', credential)
  end
end
