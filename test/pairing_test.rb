require "minitest/autorun"
# require 'minitest/hooks/default'

require Dir.pwd + "/p-adic-crypto"

class TestPairing < Minitest::Test

  def test_initialization
    pairing = Pairing.new

    assert Prime.prime?(pairing.p1)
    assert Prime.prime?(pairing.p2)
    assert pairing.r >= 1
  end

  def test_positive_pairing
    pairing = Pairing.new
    zeta = pairing.pairing(5,9)

    assert_equal [5,9], pairing.unpairing(zeta)
  end

  def test_negative_pairing
    pairing = Pairing.new
    zeta1 = pairing.pairing(-3,2)
    zeta2 = pairing.pairing(4,-7)
    zeta3 = pairing.pairing(23,-11)

    assert_equal [-3,2], pairing.unpairing(zeta1)
    assert_equal [4,-7], pairing.unpairing(zeta2)
    assert_equal [23,-11], pairing.unpairing(zeta3)
  end

  def test_rational_pairing
    pairing = Pairing.new
    zeta1 = pairing.pairing(Rational(2,7),6)
    zeta2 = pairing.pairing(-12,Rational(5,3))
    zeta3 = pairing.pairing(Rational(6,5),Rational(6,5))

    assert_equal [Rational(2,7),6], pairing.unpairing(zeta1)
    assert_equal [-12,Rational(5,3)], pairing.unpairing(zeta2)
    assert_equal [Rational(6,5),Rational(6,5)], pairing.unpairing(zeta3)
  end

end
