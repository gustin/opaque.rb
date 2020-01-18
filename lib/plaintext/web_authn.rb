class Plaintext::WebAuthn
  def self.registration_challenge(username)
    challenge, ptr = Plaintext::Library.webAuthn_register_challenge(username)
    FFI::AuthoPointer.new(ptr, Plaintext::Library.method(:webauthn_free_challenge)
    challenge
  end
end
