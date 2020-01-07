require 'ffi'
require 'plaintext/version'

module Plaintext
  OPAQUE_SIZE = 32
  ENVELOPE_SIZE = 112
  KEY_EXCHANGE_SIZE = 192

  class RegistrationStruct < FFI::Struct
    layout :beta, :pointer,
           :v, :pointer,
           :pub_s, :pointer

    def to_s
      "Result:(#{self[:beta]},#{self[:v]}),#{self[:pub_s]}"
    end
  end

  class AuthenticationStruct < FFI::Struct
    layout :beta, :pointer,
           :v, :pointer,
           :envelope, :pointer,
           :key, :pointer,
           :y, :pointer

    def to_s
      "Result:(#{self[:beta]},#{self[:v]}),#{self[:pub_s]}"
    end
  end

  module Library
    class Error < StandardError; end

    extend FFI::Library
    ffi_lib '../releases/rust-sdk/libplaintext_agent.dylib'

    attach_function :authenticate_start, [:string, :pointer, :pointer], AuthenticationStruct.by_value
    attach_function :authenticate_finalize, [:string, :pointer, :pointer], :strptr
    attach_function :free_token, [:pointer], :void

    attach_function :registration_start, [:string, :pointer], RegistrationStruct.by_value
    attach_function :registration_finalize, [:string, :pointer, :pointer], :void
  end

  class Authentication
    def self.start(username, alpha, key)
      packed_alpha = alpha.pack('C*')
      raw_alpha = FFI::MemoryPointer.from_string(packed_alpha)
      packed_key = key.pack('C*')
      raw_key = FFI::MemoryPointer.from_string(packed_key)

      result = Plaintext::Library.authenticate_start(username, raw_alpha, raw_key)

      beta = result[:beta].read_array_of_type(FFI::TYPE_UINT8, :read_uint8, OPAQUE_SIZE)
      v = result[:v].read_array_of_type(FFI::TYPE_UINT8, :read_uint8, OPAQUE_SIZE)
      envelope = result[:envelope].read_array_of_type(FFI::TYPE_UINT8, :read_uint8, ENVELOPE_SIZE)
      key = result[:key].read_array_of_type(FFI::TYPE_UINT8, :read_uint8, KEY_EXCHANGE_SIZE)
      y = result[:y].read_array_of_type(FFI::TYPE_UINT8, :read_uint8, OPAQUE_SIZE)

      [beta, v, envelope, key, y]
    end

    def self.second_factor(username)
      qr_code, ptr = AuthN::FII.generate_qr(username)
      FFI::AutoPointer.new(ptr, AuthN::FII.method(:free_qr))
      qr_code
    end

    def self.finalize(username, key, x)
      packed_key = key.pack('C*')
      raw_key = FFI::MemoryPointer.from_string(packed_key)
      packed_x = x.pack('C*')
      raw_x = FFI::MemoryPointer.from_string(packed_x)

      token, ptr = Plaintext::Library.authenticate_finalize(username, raw_key, raw_x)
      FFI::AutoPointer.new(ptr, Plaintext::Library.method(:free_token))
      token
    end
  end

  class Registration
    def self.start(username, alpha)
      # https://www.rubydoc.info/stdlib/core/Array:pack
      # C is 8-bit unsigned, * is all remaining array elements
      packed_data = alpha.pack('C*')
      raw_data = FFI::MemoryPointer.from_string(packed_data)
      result = Plaintext::Library.registration_start(username, raw_data)

      # LEAK: move to memory or auto pointers
      # ap = FFI::AutoPointer.from_native(result[:beta], nil)
      beta = result[:beta].read_array_of_type(FFI::TYPE_UINT8, :read_uint8, OPAQUE_SIZE)
      v = result[:v].read_array_of_type(FFI::TYPE_UINT8, :read_uint8, OPAQUE_SIZE)
      pub_s = result[:pub_s].read_array_of_type(FFI::TYPE_UINT8, :read_uint8, OPAQUE_SIZE)

      [beta, v, pub_s]
    end

    def self.finalize(username, public_key, envelope)
      packed_public_key = public_key.pack('C*')
      raw_public_key = FFI::MemoryPointer.from_string(packed_public_key)
      packed_envelope = envelope.pack('C*')
      raw_envelope = FFI::MemoryPointer.from_string(packed_envelope)

      result = Plaintext::Library.registration_finalize(
        username,
        raw_public_key,
        raw_envelope
      )
    end
  end

  class AuthN < FFI::AutoPointer
    def self.release(ptr)
      FII.free_qr(ptr)
    end

    def self.generate_qr(username)
      FII.generate_qr(usernamea)
    end

    def to_s
      @str ||= self.read_string.force_encoding('UTF-8')
    end

    module FII
      class Error < StandardError; end

      extend FFI::Library
      ffi_lib '../releases/rust-sdk/libplaintext_agent.dylib'

      attach_function :free_qr, :free_totp_qr, [AuthN], :void
      attach_function :generate_qr, :generate_totp_qr, [:string], :strptr
    end
  end
end
