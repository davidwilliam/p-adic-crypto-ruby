class RSAR

  attr_accessor :p, :q, :n, :phi_n, :e, :d

  def initialize(l)
    @p,@q = generate_primes(l)
    @n = @p * @q
    @phi_n = (@p - 1) * (@q - 1)
    @e = generate_e(@phi_n)
    @d = Tools.mod_inverse(@e,@phi_n)
  end

  def generate_primes(l)
    primes = nil

    while true
      primes = Array.new(2){ Tools.random_prime(l)}
      break if primes.uniq.size == 2
    end

    primes
  end

  def generate_e(phi_n)
    e = nil
    while true
      e = Tools.random_number(phi_n.bit_length / 2)
      break if e.gcd(phi_n) == 1
    end
    e
  end

  def encrypt(alpha,x)
    h = HenselCode.encode(x,1,alpha)
    # puts "h = #{h}"
    c = Tools.modular_pow(h,e,n)
  end

  def decrypt(c,x)
    h = Tools.modular_pow(c,d,n)
    # puts "h = #{h}"
    alpha = HenselCode.decode(x,1,h)
  end

  def encrypt_random(m)
    s = Tools.random_number(q.bit_length - 1)
    alpha = HenselCode.multiple_decode([p,q],1,[m,s])
    h = HenselCode.encode(n,1,alpha)
    c = Tools.modular_pow(h,e,n)
  end

  def decrypt_random(c)
    h = Tools.modular_pow(c,d,n)
    alpha = HenselCode.decode(n,1,h)
    m = HenselCode.encode(p,1,alpha)
  end
end
