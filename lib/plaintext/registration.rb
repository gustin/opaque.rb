
class Plaintext::RegistrationStruct < FFI::Struct
  layout :beta, :pointer,
         :v, :pointer,
         :pub_s, :pointer

  def to_s
    "Result:(#{self[:beta]},#{self[:v]}),#{self[:pub_s]}"
  end
end

class Plaintext::ClientRegistrationStruct < FFI::Struct
  layout :alpha, :pointer,
         :pub_u, :pointer,
         :priv_u, :pointer

  def to_s
    "Result:(#{self[:alpha]},#{self[:pub_u]}),#{self[:priv_u]}"
  end
end


class Plaintext::Registration
  def self.start(username, alpha)
    # https://www.rubydoc.info/stdlib/core/Array:pack
    # C is 8-bit unsigned, * is all remaining array elements
    packed_data = alpha.pack('C*')
    raw_data = FFI::MemoryPointer.from_string(packed_data)
    result = Plaintext::Library.registration_start(username, raw_data)

    # LEAK: move to memory or auto pointers
    # ap = FFI::AutoPointer.from_native(result[:beta], nil)
    beta = result[:beta].read_array_of_type(
      FFI::TYPE_UINT8, :read_uint8, Plaintext::OPAQUE_FACTOR_SIZE
    )
    v = result[:v].read_array_of_type(
      FFI::TYPE_UINT8, :read_uint8, Plaintext::OPAQUE_FACTOR_SIZE
    )
    pub_s = result[:pub_s].read_array_of_type(
      FFI::TYPE_UINT8, :read_uint8, Plaintext::OPAQUE_FACTOR_SIZE
    )

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

  def self.client_start(password)
    result = Plaintext::Library.opaque_client_registration_start(password)

    alpha = result[:alpha].read_array_of_type(
      FFI::TYPE_UINT8, :read_uint8, Plaintext::OPAQUE_FACTOR_SIZE
    )
    pub_u = result[:pub_u].read_array_of_type(
      FFI::TYPE_UINT8, :read_uint8, Plaintext::OPAQUE_FACTOR_SIZE
    )
    priv_u = result[:priv_u].read_array_of_type(
      FFI::TYPE_UINT8, :read_uint8, Plaintext::OPAQUE_FACTOR_SIZE
    )

    [alpha, pub_u, priv_u]
  end
end
