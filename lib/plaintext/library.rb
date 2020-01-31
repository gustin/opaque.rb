
module Plaintext::Library
  class Error < StandardError; end

  extend FFI::Library
  ffi_lib '../releases/core-sdk/libplaintext_core_sdk_v0.1.1.dylib'

  # authentication, currently via 1 knowledge factor (opaque)
  attach_function :authenticate_start, [:string, :pointer, :pointer],
    Plaintext::AuthenticationStruct.by_value
  attach_function :authenticate_finalize,
    [:string, :pointer, :pointer], :strptr
  attach_function :free_token, [:pointer], :void

  # registration
  attach_function :registration_start, [:string, :pointer],
    Plaintext::RegistrationStruct.by_value
  attach_function :registration_finalize,
    [:string, :pointer, :pointer], :void

  # client registration
  attach_function :opaque_client_registration_start, [:string],
    Plaintext::ClientRegistrationStruct.by_value

  # authenticator, 2nd factor, possession
  attach_function :generate_qr_code, :generate_qr_code, [:string], :strptr
  attach_function :free_qr_code, :free_qr_code, [:string], :void

  attach_function :confirm_second_factor, [:string, :string], :bool

  # webauthn
  attach_function :webauthn_registration_challenge, [:string], :strptr
  attach_function :webauthn_free_challenge, [:string], :void
  attach_function :webauthn_register_credential, [:string, :string], :bool
end
