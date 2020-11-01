# DC stands for Distributed Computation
class DC

  attr_accessor :k, :l, :p_primes, :q_primes, :order, :parties

  def initialize(k,l)
    @k = k
    @l = l
    @d = 2
    @p_primes = generate_primes(@l)
    @q_primes = generate_primes(@d * @l)
    @order = (0..k-1).to_a.shuffle
  end

  def generate_primes(bit_size)
    primes = nil

    while true
      primes = Array.new(k){ Tools.random_prime(bit_size) }
      break if primes.uniq.size == k
    end

    primes
  end

  def generate_digits(m)
    s = Array.new(k-1){ Tools.random_number(l - 1) }
    # puts "s = #{s}"
    m_digits = [m] + s
    alpha = HenselCode.multiple_decode(p_primes,1,m_digits)
    # puts "alpha = #{alpha}"
    h_digits = HenselCode.multiple_encode(q_primes,1,alpha)
  end

  def generate_parties
    @parties = []
    k.times do |i|
      @parties << Party.new(i)
    end
  end

  def assign_digits(a_digits,b_digits)
    order.each_with_index do |o,i|
      parties[i].a = a_digits[o]
      parties[i].b = b_digits[o]
    end
  end

  def request_addition
    parties.each{|party| party.add }
  end

  def request_multiplication
    parties.each{|party| party.mul }
  end

  def retrieve_addition
    c_digits = Array.new(k,nil)

    parties.each_with_index do |party,i|
      c_digits[order[i]] = party.add_result
    end

    # puts "c_digits = #{c_digits}"

    # c_digits = parties.map{|party| party.add_result}
    alpha = HenselCode.multiple_decode(q_primes,1,c_digits)
    # puts "alpha = #{alpha}"
    c = HenselCode.encode(p_primes[0],1,alpha)
  end

  def retrieve_multiplication
    c_digits = Array.new(k,nil)

    parties.each_with_index do |party,i|
      c_digits[order[i]] = party.mul_result
    end

    # puts "c_digits = #{c_digits}"

    # c_digits = parties.map{|party| party.mul_result}
    alpha = HenselCode.multiple_decode(q_primes,1,c_digits)
    # puts "alpha = #{alpha}"
    c = HenselCode.encode(p_primes[0],1,alpha)
  end

end
