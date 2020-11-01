require "minitest/autorun"
# require 'minitest/hooks/default'

require Dir.pwd + "/p-adic-crypto"

class TestPAdicCrypto < Minitest::Test

  def test_encrypt_and_decrypt
    k = Gen.new(8)

    m1 = 5
    m2 = 3

    c1 = PAdicCrypto.encrypt(k,m1)
    c2 = PAdicCrypto.encrypt(k,m2)

    m1_d = PAdicCrypto.decrypt(k,c1)
    m2_d = PAdicCrypto.decrypt(k,c2)

    assert_equal m1_d, m1
    assert_equal m2_d, m2
  end

  def test_homomorphic_addition
    k = Gen.new(8)

    m1 = 5
    m2 = 3

    c1 = PAdicCrypto.encrypt(k,m1)
    c2 = PAdicCrypto.encrypt(k,m2)

    c3 = PAdicCrypto.add(k.g,c1,c2)

    m3_d = PAdicCrypto.decrypt(k,c3)

    assert_equal m1 + m2, m3_d
  end

  def test_homomorphic_subtraction
    k = Gen.new(8)

    m1 = 5
    m2 = 3

    c1 = PAdicCrypto.encrypt(k,m1)
    c2 = PAdicCrypto.encrypt(k,m2)

    c3 = PAdicCrypto.sub(k.g,c1,c2)

    m3_d = PAdicCrypto.decrypt(k,c3)

    assert_equal m1 - m2, m3_d
  end

  def test_homomorphic_multiplication
    k = Gen.new(8)

    m1 = 5
    m2 = 3

    c1 = PAdicCrypto.encrypt(k,m1)
    c2 = PAdicCrypto.encrypt(k,m2)

    c3 = PAdicCrypto.mul(k.g,c1,c2)

    m3_d = PAdicCrypto.decrypt(k,c3)

    assert_equal m1 * m2, m3_d
  end

  def test_encryption_of_zero
    k = Gen.new(8)

    m1 = 0
    m2 = 0

    c1 = PAdicCrypto.encrypt(k,m1)
    c2 = PAdicCrypto.encrypt(k,m2)

    assert c1 != 0
    assert c2 != 0
  end
end
