require 'ffi'
require 'plaintext/version'

module Plaintext
  class AuthN < FFI::AutoPointer
    def self.release(ptr)
      FII.free_qr(ptr)
    end

    def self.generate_qr(username)
      FII.generate_qr(username)
    end

    def self.registration_1(username, password)
      FFI.registration_1(username, password)
    end

    def to_s
      @str ||= self.read_string.force_encoding('UTF-8')
    end

    module FII
      class Error < StandardError; end

      extend FFI::Library
      ffi_lib '../agent/target/debug/libplaintext_agent.dylib'
      attach_function :registration_1, [:string, :string], :void

      attach_function :generate_qr, :generate_totp_qr, [:string], AuthN
      attach_function :free_qr, :free_totp_qr, [AuthN], :void
    end
  end

end
