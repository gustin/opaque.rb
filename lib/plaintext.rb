require 'ffi'


module Plaintext
  OPAQUE_FACTOR_SIZE = 32
  OPAQUE_ENVELOPE_SIZE = 112
  SIGMA_KEY_EXCHANGE_SIZE = 192
end


require 'plaintext/version'
require 'plaintext/authentication'
require 'plaintext/authenticator'
require 'plaintext/registration'
require 'plaintext/library'
