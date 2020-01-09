
module Plaintext::Library
  class Error < StandardError; end

  extend FFI::Library
  ffi_lib '../releases/rust-sdk-core/libplaintext_sdk_core_v0.1.1.dylib'

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

  attach_function :confirm_second_factor, [:string], :bool
end
