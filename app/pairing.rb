class Pairing

  attr_accessor :a, :b, :p1, :p2, :r

  def initialize()

    primes = nil

    while true
      primes = Array.new(2){ Tools.random_prime(16) }
      break if primes.uniq.size == 2
    end

    @p1 = primes[0]
    @p2 = primes[1]
    @r = 1
  end

  def pairing(alpha,beta)
    h1 = HenselCode.encode(p1,r,alpha)
    h2 = HenselCode.encode(p2,r,beta)
    g, zeta = HenselCode.decode_helper([p1**r,p2**r],[h1,h2])
    zeta
  end

  def unpairing(zeta)
    h1 = zeta % p1
    h2 = zeta % p2
    alpha = HenselCode.decode(p1,r,h1)
    beta = HenselCode.decode(p2,r,h2)
    [alpha, beta]
  end

end
