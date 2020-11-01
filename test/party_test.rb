require "minitest/autorun"
# require 'minitest/hooks/default'

require Dir.pwd + "/p-adic-crypto"

class TestParty < Minitest::Test

  def test_initialization
    party = Party.new(1)

    assert_equal 1, party.pid
    assert_equal "Party-1", party.name
  end

  def test_addtion_and_multiplication
    party = Party.new(1)

    party.a = 3
    party.b = 4

    party.add
    party.mul

    assert_equal 3 + 4, party.add_result
    assert_equal 3 * 4, party.mul_result
  end

end
