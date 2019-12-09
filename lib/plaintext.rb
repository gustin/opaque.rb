require 'ffi'
require 'plaintext/version'

module Plaintext
  class Registration < FFI::Struct
    layout :beta, :pointer,
           :v, :pointer,
           :pub_s, :pointer
  end

  class AuthN < FFI::AutoPointer
    def self.release(ptr)
      FII.free_qr(ptr)
    end

    def self.generate_qr(username)
      FII.generate_qr(username)
    end

    def self.registration_1(username, alpha)
      # https://www.rubydoc.info/stdlib/core/Array:pack
      # C is 8-bit unsigned, * is all remaining array elements
      packed_data = alpha.pack("C*")
      raw_data = FFI::MemoryPointer.from_string(packed_data)
      FFI.registration_1(username, raw_data)

      # raw_data.get_bytes(0, width * height).unpack("C*")


      # Note, other option:
      # https://github.com/ffi/ffi/wiki/Binary-data
      # memBuf = FFI::MemoryPointer.new(:char, data.bytesize)
      # memBuf.put_bytes(0, data)
    end

    def to_s
      @str ||= self.read_string.force_encoding('UTF-8')
    end

    module FII
      class Error < StandardError; end

      extend FFI::Library
      ffi_lib '../agent/target/debug/libplaintext_agent.dylib'
      attach_function :registration_1, [:string, :pointer], Registration

      attach_function :generate_qr, :generate_totp_qr, [:string], AuthN
      attach_function :free_qr, :free_totp_qr, [AuthN], :void
    end
  end

end
