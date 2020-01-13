class Plaintext::Authenticator
  def self.generate_second_factor(username)
    qr_code, ptr = Plaintext::Library.generate_qr_code(username)
    FFI::AutoPointer.new(ptr, Plaintext::Library.method(:free_qr_code))

    qr_code
  end

  def self.confirm_second_factor(username, code)
#    packed_code = code.pack('C*')
#    raw_code = FFI::MemoryPointer.from_string(code)
    valid = Plaintext::Library.confirm_second_factor(username, code)
  end
end
