require "minitest/autorun"
# require 'minitest/hooks/default'

require Dir.pwd + "/p-adic-crypto"

class TestDC < Minitest::Test

  def test_initialization
    dc = DC.new(4,16)

    assert_equal 4, dc.k
    assert_equal 16, dc.l
    assert_equal 4, dc.p_primes.size
    assert_equal 4, dc.q_primes.size
    assert_equal [16], dc.p_primes.map{|prime| prime.bit_length }.uniq
    assert_equal [32], dc.q_primes.map{|prime| prime.bit_length }.uniq
  end

  def test_generate_parties
    dc = DC.new(4,16)
    dc.generate_parties

    assert_equal [0,"Party-0"], [dc.parties[0].pid,dc.parties[0].name]
    assert_equal [1,"Party-1"], [dc.parties[1].pid,dc.parties[1].name]
    assert_equal [2,"Party-2"], [dc.parties[2].pid,dc.parties[2].name]
    assert_equal [3,"Party-3"], [dc.parties[3].pid,dc.parties[3].name]
  end

  def test_generate_digits
    dc = DC.new(4,16)
    dc.generate_parties
    digits = dc.generate_digits(23)

    alpha = HenselCode.multiple_decode(dc.q_primes,1,digits)

    assert_equal 23, HenselCode.encode(dc.p_primes[0],1,alpha)
  end

  def test_assign_digits
    dc = DC.new(4,16)
    dc.generate_parties

    a_digits = dc.generate_digits(42)
    b_digits = dc.generate_digits(39)

    dc.assign_digits(a_digits,b_digits)

    dc.order.each_with_index do |o,i|
      assert_equal a_digits[o], dc.parties[i].a
      assert_equal b_digits[o], dc.parties[i].b
    end
  end

  def test_request_addition
    dc = DC.new(4,16)
    dc.generate_parties

    a_digits = dc.generate_digits(42)
    b_digits = dc.generate_digits(39)

    dc.assign_digits(a_digits,b_digits)

    dc.request_addition

    dc.order.each_with_index do |o,i|
      assert_equal a_digits[o] + b_digits[o], dc.parties[i].add_result
    end
  end

  def test_request_multiplication
    dc = DC.new(4,16)
    dc.generate_parties

    a_digits = dc.generate_digits(42)
    b_digits = dc.generate_digits(39)

    dc.assign_digits(a_digits,b_digits)

    dc.request_multiplication

    dc.order.each_with_index do |o,i|
      assert_equal a_digits[o] * b_digits[o], dc.parties[i].mul_result
    end
  end

  def test_retrieve_addition
    dc = DC.new(4,16)
    dc.generate_parties

    a_digits = dc.generate_digits(42)
    b_digits = dc.generate_digits(39)

    dc.assign_digits(a_digits,b_digits)

    dc.request_addition

    a_add_b = dc.retrieve_addition

    assert_equal 42 + 39, a_add_b
  end

end
