require "test_helper"

class PlaintextTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Plaintext::VERSION
  end

  def test_generating_totp
    puts "~)- Ruby Land ~)-"
    puts PlaintextTotp::ToTp.generate_qr("user 12")
  end
end
