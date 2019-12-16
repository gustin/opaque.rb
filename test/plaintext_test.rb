require 'test_helper'

class PlaintextTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Plaintext::VERSION
  end

  def test_registration
    puts '~) Registration OPAQUE Via Ruby ~)'
    alpha = [174, 17, 253, 238, 61, 54, 246, 96, 134, 222, 69, 115, 52, 224, 182, 129, 135, 201, 31, 217, 76, 37, 186, 203, 89, 193, 216, 214, 86, 253, 86, 64]
    beta, v, pub_s = Plaintext::Registration.start('larry', alpha)
    puts "Beta: #{beta}"
    puts "V: #{v}"
    puts "PubS: #{pub_s}"

    puts '=> Registration Finalization'
    pub_u = [66, 201, 176, 218, 140, 167, 47, 224, 172, 151, 34, 253, 118, 87, 150, 144, 70, 2, 65, 33, 87, 169, 70, 95, 33, 2, 205, 73, 114, 47, 219, 30]
    puts pub_u.size
    envelope = [136, 226, 117, 147, 98, 67, 222, 87, 40, 28, 138, 112, 92, 8, 211, 140, 249, 0, 90, 34, 210, 81, 129, 190, 9, 172, 118, 200, 57, 150, 77, 123, 135, 109, 152, 179, 213, 211, 221, 248, 230, 61, 185, 87, 212, 218, 190, 202, 203, 141, 255, 130, 255, 58, 149, 41, 147, 2, 125, 168, 123, 43, 240, 55, 157, 52, 145, 79, 107, 10, 202, 37, 117, 213,  75, 90, 4, 54, 171, 156, 20, 224, 53, 232, 101, 160, 157, 179, 144, 252, 204, 203, 164,  51, 87, 118, 165, 123, 177, 221, 182, 206, 87, 182, 27, 226, 90, 7, 9, 109, 53, 182]
    puts envelope.size
    Plaintext::Registration.finalize('larry', pub_u, envelope)

    puts '~) Authenticating OPAQUE Via Ruby ~)'
    alpha = [174, 17, 253, 238, 61, 54, 246, 96, 134, 222, 69, 115, 52, 224, 182, 129, 135, 201, 31, 217, 76, 37, 186, 203, 89, 193, 216, 214, 86, 253, 86, 64]
    key = [174, 17, 253, 238, 61, 54, 246, 96, 134, 222, 69, 115, 52, 224, 182, 129, 135, 201, 31, 217, 76, 37, 186, 203, 89, 193, 216, 214, 86, 253, 86, 64]
    beta, v, envelope, key, y = Plaintext::Authentication.start('larry', alpha, key)
    puts "Beta: #{beta}"
    puts "V: #{v}"
    puts "Envelope: #{envelope}"
    puts "Key: #{key}"
    puts "Y: #{y}"
  end

  def test_generating_totp
    skip('Not doing it..')
    puts '~)- Ruby Land ~)-'
    puts Plaintext::AuthN.generate_qr('user 12')
  end
end
