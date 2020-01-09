require 'ffi'

module Plaintext
  OPAQUE_FACTOR_SIZE = 32
  OPAQUE_ENVELOPE_SIZE = 112
  SIGMA_KEY_EXCHANGE_SIZE = 192

  module Library
    class Error < StandardError; end

    extend FFI::Library
    ffi_lib '../releases/rust-sdk/libplaintext_agent.dylib'

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

    # authenticator, 2nd factor, possession
    attach_function :generate_qr_code, :generate_qr_code, [:string], :strptr
    attach_function :free_qr_code, :free_qr_code, [:string], :void
  end
end

require 'plaintext/version'
require 'plaintext/authentication'
require 'plaintext/authenticator'
require 'plaintext/registration'
