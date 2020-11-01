require "minitest/autorun"
# require 'minitest/hooks/default'

require Dir.pwd + "/p-adic-crypto"

class TestHenselCode < Minitest::Test

  def test_hensel_encode
    r_exp = 1
    p = 257
    m = Rational(5,3)

    h = HenselCode.encode(p,r_exp,m)
    assert_equal 173, h
  end

  def test_hensel_decode
    r_exp = 1
    p = 257
    h = 173

    m = HenselCode.decode(p,r_exp,h)
    assert_equal Rational(5,3), m
  end

  def test_multiple_hensel_encode
    r_exp = 1
    p = 257
    q = 281
    m = Rational(5,3)

    h = HenselCode.multiple_encode([p,q],r_exp,m)
    assert_equal [173,189], h
  end

  def test_multiple_hensel_decode
    r_exp = 1
    p = 257
    q = 281
    h = [173,189]

    m = HenselCode.multiple_decode([p,q],r_exp,h)
    assert_equal Rational(5,3), m
  end

  def test_addition_with_single_hensel_code
    r_exp = 1
    p = 54959
    m1 = Rational(5,3)
    m2 = Rational(7,4)

    h1 = HenselCode.encode(p,r_exp,m1)
    h2 = HenselCode.encode(p,r_exp,m2)
    h3 = h1 + h2

    m3 = HenselCode.decode(p,r_exp,h3)
    assert_equal m1 + m2, m3
  end

  def test_multiplication_with_single_hensel_code
    r_exp = 1
    p = 54959
    m1 = Rational(5,3)
    m2 = Rational(7,4)

    h1 = HenselCode.encode(p,r_exp,m1)
    h2 = HenselCode.encode(p,r_exp,m2)
    h3 = h1 * h2

    m3 = HenselCode.decode(p,r_exp,h3)
    assert_equal m1 * m2, m3
  end

  def test_addition_with_multiple_hensel_code
    r_exp = 1
    p = 54959
    q = 60647
    m1 = Rational(5,3)
    m2 = Rational(7,4)

    h1 = HenselCode.multiple_encode([p,q],r_exp,m1)
    h2 = HenselCode.multiple_encode([p,q],r_exp,m2)
    h3 = [h1[0] + h2[0], h1[1] + h2[1]]

    m3 = HenselCode.multiple_decode([p,q],r_exp,h3)
    assert_equal m1 + m2, m3
  end

  def test_multiplication_with_multiple_hensel_code
    r_exp = 1
    p = 54959
    q = 60647
    m1 = Rational(5,3)
    m2 = Rational(7,4)

    h1 = HenselCode.multiple_encode([p,q],r_exp,m1)
    h2 = HenselCode.multiple_encode([p,q],r_exp,m2)
    h3 = [h1[0] * h2[0], h1[1] * h2[1]]

    m3 = HenselCode.multiple_decode([p,q],r_exp,h3)
    assert_equal m1 * m2, m3
  end

  def test_addition_with_inverse_multiple_hensel_code
    r_exp = 1
    p = 54959
    q = 60647

    h1 = [5,23]
    h2 = [5,17]

    m1 = HenselCode.multiple_decode([p,q],r_exp,h1)
    m2 = HenselCode.multiple_decode([p,q],r_exp,h2)
    m3 = m1 + m2

    h3 = HenselCode.multiple_encode([p,q],r_exp,m3)
    assert_equal [10,40], h3
  end

  def test_multiplication_with_inverse_multiple_hensel_code
    r_exp = 1
    p = 54959
    q = 60647

    h1 = [5,23]
    h2 = [5,17]

    m1 = HenselCode.multiple_decode([p,q],r_exp,h1)
    m2 = HenselCode.multiple_decode([p,q],r_exp,h2)
    m3 = m1 * m2

    h3 = HenselCode.multiple_encode([p,q],r_exp,m3)
    assert_equal [25,391], h3
  end
end
