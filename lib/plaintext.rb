require 'ffi'
require 'plaintext/version'

module Plaintext
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
    ffi_lib '../agent/target/debug/libplaintext_agent.dylib'

    attach_function :authenticate_start, [:string, :pointer, :pointer], AuthenticationStruct.by_value
    attach_function :authenticate_finalize, [:string, :pointer, :pointer], :void

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

      beta = result[:beta].read_array_of_type(FFI::TYPE_UINT8, :read_uint8, 32)
      puts '***** Beta'
      puts beta.inspect
      v = result[:v].read_array_of_type(FFI::TYPE_UINT8, :read_uint8, 32)
      puts '***** V'
      puts v.inspect
      envelope = result[:envelope].read_array_of_type(FFI::TYPE_UINT8, :read_uint8, 112)
      puts '*** Envelope'
      puts envelope.inspect

      key = result[:key].read_array_of_type(FFI::TYPE_UINT8, :read_uint8, 192)
      puts '***** Key'
      puts key.inspect
      y = result[:y].read_array_of_type(FFI::TYPE_UINT8, :read_uint8, 32)
      puts '***** Y'
      puts v.inspect

      [beta, v, envelope, key, y]
    end

    def self.finalize(username, key, x)
      packed_key = key.pack('C*')
      raw_key = FFI::MemoryPointer.from_string(packed_key)
      packed_x = x.pack('C*')
      raw_x = FFI::MemoryPointer.from_string(packed_x)

      result = Plaintext::Library.authenticate_finalize(username, raw_key, raw_x)
    end
  end

  class Registration
    def self.start(username, alpha)
      # https://www.rubydoc.info/stdlib/core/Array:pack
      # C is 8-bit unsigned, * is all remaining array elements
      packed_data = alpha.pack('C*')
      raw_data = FFI::MemoryPointer.from_string(packed_data)
      result = Plaintext::Library.registration_start(username, raw_data)

      #      beta = FFI::MemoryPointer.new(:char, 32)
      #      beta.put_bytes(0, result[:beta])

      # LEAK: move to memory or auto pointers
      # ap = FFI::AutoPointer.from_native(result[:beta], nil)
      beta = result[:beta].read_array_of_type(FFI::TYPE_UINT8, :read_uint8, 32)
      puts '***** Beta'
      puts beta.inspect
      v = result[:v].read_array_of_type(FFI::TYPE_UINT8, :read_uint8, 32)
      puts '***** V'
      puts v.inspect
      pub_s = result[:pub_s].read_array_of_type(FFI::TYPE_UINT8, :read_uint8, 32)
      #      puts pub_s

      # raw_data.get_bytes(0, width * height).unpack("C*")

      # Note, other option:
      # https://github.com/ffi/ffi/wiki/Binary-data
      # memBuf = FFI::MemoryPointer.new(:char, data.bytesize)
      # memBuf.put_bytes(0, data)
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
      FII.generate_qr(username)
    end

    def to_s
      @str ||= self.read_string.force_encoding('UTF-8')
    end

    module FII
      class Error < StandardError; end

      extend FFI::Library
      ffi_lib '../agent/target/debug/libplaintext_agent.dylib'

      attach_function :free_qr, :free_totp_qr, [AuthN], :void
      attach_function :generate_qr, :generate_totp_qr, [:string], AuthN
    end
  end
end
