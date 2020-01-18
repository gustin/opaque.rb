class Plaintext::WebAuthn
  def self.registration_challenge(username)
    challenge, ptr = Plaintext::Library.webauthn_registration_challenge(username)
    FFI::AutoPointer.new(ptr, Plaintext::Library.method(:webauthn_free_challenge))
    challenge
  end
end
