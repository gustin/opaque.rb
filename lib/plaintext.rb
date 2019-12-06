require 'ffi'
require "plaintext/version"

class PlaintextTotp < FFI::AutoPointer
  def self.release(ptr)
    Totp.free_qr(ptr)
  end

  def to_s
    @str ||= self.read_string.force_encoding('UTF-8')
  end

  module ToTp
    class Error < StandardError; end

    extend FFI::Library
    ffi_lib '../agent/target/debug/libplaintext_agent.dylib'
    attach_function :generate_qr, :generate_totp_qr, [:string], PlaintextTotp
    attach_function :free_qr, :free_totp_qr, [PlaintextTotp], :void
  end
end


