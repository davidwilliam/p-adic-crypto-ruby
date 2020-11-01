class HenselCode

    # p is and odd prime number
    # r is an arbitrary positive integer
    # m is a rational number of the form c/d
    # such that c,d and p^r are all pairwise coprime
    def self.encode(p,r,m)
      c = m.numerator
      d = m.denominator
      d_inv = Tools.mod_inverse(d,p**r)
      h = (c * d_inv) % p**r
      return h
    end

    def self.decode(p,r,h)
      n = 0
      a = [p**r, h]; n += 1
      y = [0,1] ; n += 1
      i = 1 ; n += 1

      while a[i] > Integer.sqrt((p**r)/2)
        q = a[i - 1] / a[i] ; n += 1
        # puts "q = #{q}"
        a[i + 1] = a[i - 1] - q * a[i] ; n += 1
        # puts "a[i - 1] = #{a[i - 1]}"
        # puts "a[i] = #{a[i]}"
        # puts "a[i + 1] = #{a[i + 1]}\n\n"
        y[i + 1] = y[i - 1] + q * y[i] ; n += 1
        i = i + 1 ; n += 1
      end

      c = (-1)**(i + 1) * a[i]; ; n += 1
      d = y[i] ; n += 1

      # puts "n = #{n}"

      return Rational(c,d)
    end

    def self.multiple_encode(primes,r,m)
        primes.map do |prime|
            encode(prime,r,m)
        end
    end

    def self.decode_helper(primes,codes)
        g = 1
        (0..primes.size-1).each do |i|
          g = g * primes[i]
        end

        i = 0
        z = 0
        codes.each do |h|
          p_factor = g / primes[i]
          p_prime = Tools.mod_inverse(p_factor,primes[i])
          z = z + ((p_factor * p_prime * h))
          i+=1
        end

        z = z % g
        [g,z]
      end

    def self.multiple_decode(primes,r,codes)
        g,z = decode_helper(primes.map{|p| p**r},codes)
        # puts "\n\ng = #{g}"
        # puts "z = #{z}\n\n"
        decode(g,r,z)
    end

  end
