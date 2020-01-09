
class Plaintext::AuthenticationStruct < FFI::Struct
  layout :beta, :pointer,
    :v, :pointer,
    :envelope, :pointer,
    :key, :pointer,
    :y, :pointer

  def to_s
    "Result:(#{self[:beta]},#{self[:v]}),#{self[:pub_s]}"
  end
end

class Plaintext::Authentication
  def self.start(username, alpha, key)
    packed_alpha = alpha.pack('C*')
    raw_alpha = FFI::MemoryPointer.from_string(packed_alpha)
    packed_key = key.pack('C*')
    raw_key = FFI::MemoryPointer.from_string(packed_key)

    result = Plaintext::Library.authenticate_start(username, raw_alpha, raw_key)

    beta = result[:beta].read_array_of_type(
      FFI::TYPE_UINT8, :read_uint8, Plaintext::OPAQUE_FACTOR_SIZE
    )
    v = result[:v].read_array_of_type(
      FFI::TYPE_UINT8, :read_uint8, Plaintext::OPAQUE_FACTOR_SIZE
    )
    envelope = result[:envelope].read_array_of_type(
      FFI::TYPE_UINT8, :read_uint8, Plaintext::OPAQUE_ENVELOPE_SIZE
    )
    key = result[:key].read_array_of_type(
      FFI::TYPE_UINT8, :read_uint8, Plaintext::SIGMA_KEY_EXCHANGE_SIZE
    )
    y = result[:y].read_array_of_type(
      FFI::TYPE_UINT8, :read_uint8, Plaintext::OPAQUE_FACTOR_SIZE
    )

    [beta, v, envelope, key, y]
  end

  def self.generate_second_factor(username)
    qr_code, ptr = Plaintext::Library.generate_qr_code(username)
    FFI::AutoPointer.new(ptr, Plaintext::Library.method(:free_qr_code))
    qr_code
  end

  def self.confirm_second_factor(code)
    packed_code = key.pack('C*')
    raw_code = FFI::MemoryPointer.from_string(packed_factor)

    valid = Plaintext::Library.authenticate_confirm_code(raw_code)
  end

  def self.finalize(username, key, x)
    packed_key = key.pack('C*')
    raw_key = FFI::MemoryPointer.from_string(packed_key)
    packed_x = x.pack('C*')
    raw_x = FFI::MemoryPointer.from_string(packed_x)

    token, ptr = Plaintext::Library.authenticate_finalize(
      username, raw_key, raw_x
    )
    FFI::AutoPointer.new(ptr, Plaintext::Library.method(:free_token))
    token
  end
end
