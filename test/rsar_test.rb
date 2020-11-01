require "minitest/autorun"
# require 'minitest/hooks/default'

require Dir.pwd + "/p-adic-crypto"

class TestDC < Minitest::Test

  def test_initialization
    rsar = RSAR.new(16)

    assert_equal 16, rsar.p.bit_length
    assert_equal 16, rsar.q.bit_length
    assert_equal 32, rsar.n.bit_length
    assert_equal 1, (rsar.e * rsar.d) % rsar.phi_n
  end

  def test_encrypt_p
    rsar = RSAR.new(16)

    alpha = Rational(3,5)
    c = rsar.encrypt(alpha,rsar.p)

    assert_equal alpha, rsar.decrypt(c,rsar.p)
  end

  def test_encrypt_p
    rsar = RSAR.new(16)

    alpha = Rational(3,5)
    c = rsar.encrypt(alpha,rsar.p)

    assert_equal alpha, rsar.decrypt(c,rsar.p)
  end

  def test_encrypt_q
    rsar = RSAR.new(16)

    alpha = Rational(2,9)
    c = rsar.encrypt(alpha,rsar.q)

    assert_equal alpha, rsar.decrypt(c,rsar.q)
  end

  def test_encrypt_n
    rsar = RSAR.new(16)

    alpha = Rational(4,7)
    c = rsar.encrypt(alpha,rsar.n)

    assert_equal alpha, rsar.decrypt(c,rsar.n)
  end

  def test_homomorphic_multiplication
    rsar = RSAR.new(16)

    alpha1 = Rational(3,4)
    alpha2 = Rational(2,7)

    c1 = rsar.encrypt(alpha1,rsar.n)
    c2 = rsar.encrypt(alpha2,rsar.n)

    c1_times_c2 = (c1 * c2) % rsar.n

    assert_equal alpha1 * alpha2, rsar.decrypt(c1_times_c2,rsar.n)
  end

  def test_encrypt_random
    rsar = RSAR.new(16)

    m1 = 24
    m2 = 39

    c1 = rsar.encrypt_random(m1)
    c2 = rsar.encrypt_random(m2)

    assert_equal m1, rsar.decrypt_random(c1)
    assert_equal m2, rsar.decrypt_random(c2)
  end

end
