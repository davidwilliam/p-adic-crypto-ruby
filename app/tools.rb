class Tools

    def self.random_number(bits)
        OpenSSL::BN::rand(bits).to_i
      end

      def self.random_prime(bits)
        # recall that OpenSLL library does no generate primes with less than
        # 16 bits
        if bits < 16
          Prime.first(100).select{|prime| prime.bit_length == 8}.sample
        else
          OpenSSL::BN::generate_prime(bits).to_i
        end
      end

      def self.modular_pow( base, power, mod )
        res = 1
        while power > 0
          res = (res * base) % mod if power & 1 == 1
          base = base ** 2 % mod
          power >>= 1
        end
        res
      end

      def self.mod_inverse(num, mod)
        g, a, b = extended_gcd(num, mod)
        unless g == 1
          raise ZeroDivisionError.new("#{num} has no inverse modulo #{mod}")
        end
        a % mod
      end

      def self.extended_gcd(x, y)
        if x < 0
          g, a, b = extended_gcd(-x, y)
          return [g, -a, b]
        end
        if y < 0
          g, a, b = extended_gcd(x, -y)
          return [g, a, -b]
        end
        r0, r1 = x, y
        a0 = b1 = 1
        a1 = b0 = 0
        until r1.zero?
          q = r0 / r1
          r0, r1 = r1, r0 - q*r1
          a0, a1 = a1, a0 - q*a1
          b0, b1 = b1, b0 - q*b1
        end
        [r0, a0, b0]
      end

      def self.meea(p,r,h)
        a = [p**r, h]
        y = [0, 1]
        i = 1

        # puts "\\left.\\begin{array}{l}"
        # puts "a_{0}=g^{r}=60491,\\:a_{1}=z=3615\\\\"
        # puts "y_{0}=0,\\:y_{1}=1\\\\"
        # puts "i=1\\\\"
        # puts "\\\\"

        while a[i] > Integer.sqrt((p**r)/2)
          q = a[i-1] / a[i]
          a << (a[i-1] - q * a[i])
          y << (y[i-1] + q * y[i])
          i += 1

          # puts "q = #{q}"
          # puts "a = #{a}"
          # puts "y = #{y}"
          # puts "i = #{i}\n\n"
          # puts "q=\\left\\lfloor a_{0}\\big/a_{1}\\right\\rfloor = #{q}\\\\"
          # puts "a_{2}=a_{1}-q\\cdot a_{0}= #{a[i]}\\\\"
          # puts "y_{2}=y_{1}-q\\cdot y_{0}= #{y[i]}\\\\"
          # puts "i=#{i}\\\\"
          # puts "\\\\"
        end

        c = (-1)**(i+1) * a[i]
        d = y[i]

        # puts "c=\\left(-1\\right)^{i+1}\\cdot a_{i}=#{c}\\\\"
        # puts "d=y_{i}=#{d}"
        # puts "\\end{array}\\right."

        Rational(c,d)
      end

      def self.euler_totient(n)
        phi_n = 1
        (n - 1).times do |i|
          phi_n += 1 if i.gcd(n) == 1
        end
        phi_n
      end

      def self.factor_totient(n,phi_n)
        a = 1
        b = -(n + 1 - phi_n)
        c = n

        p = ((-b + Math.sqrt((((b).abs) ** 2) - (4 * a * c)))/2).to_i
        q = ((-b - Math.sqrt((((b).abs) ** 2) - (4 * a * c)))/2).to_i

        [p,q]
      end

      def self.trial_division(g)
        k = []

        while g % 2 == 0
          k.append(2)
          g /= 2
        end

        b = 3

        while b * b <= g
          if g % b == 0
            k.append(b)
            g /= b
          else
            b += 2
          end
        end

        if g != 1
          k.append(g)
        end
        # Only odd number is possible
        return k
      end

      def self.lll_2D(v1,v2)
        # puts "v1 = #{v1}, v2 = #{v2}"
        v1_ = v1.dup
        v2_ = v2 - (v2.dot(v1_).to_f / v1_.dot(v1_).to_f) * v1
        v2 = v2 - (v2.dot(v1_) / v1_.dot(v1_)) * v1

        mu = v2.dot(v1_).to_f / v1_.dot(v1_).to_f

        # puts "v1 = #{v1}, v2 = #{v2}"

        while (v2_.magnitude**2 >= ((3.0/4.0 - mu**2) * v1_.magnitude**2)) == false
          v1aux = v2.dup; v2aux = v1.dup
          v1 = v1aux; v2 = v2aux

          v1_ = v1.dup
          v2_ = v2 - (v2.dot(v1_).to_f / v1_.dot(v1_).to_f) * v1
          v2 = v2 - (v2.dot(v1_) / v1_.dot(v1_)) * v1

          mu = v2.dot(v1_).to_f / v1_.dot(v1_).to_f

          # puts "v1 = #{v1}, v2 = #{v2}."
        end

        [v1,v2]
      end

      def self.factorial(n)
        (1..n).inject(:*) || 1
      end

      def self.p_adic_factorial(n,primes)
        # size = 2*n+2+1
        # primes = Prime.first(size)
        # n_f = factorial(n)
        # h_f = HenselCode.multiple_encode(primes,1,Rational(n_f,1))
        #
        # puts "n_f = #{n_f}"
        # puts "h_f = #{h_f}"

        # h_f_calc = primes.map{|prime| Tools.mod_factorial(n,prime)}
        # h_f_calc = Parallel.map(primes, in_threads: n) { |prime| Tools.mod_factorial(n,prime) }

        threads = []
        primes.each{|prime| threads << Thread.new { Tools.mod_factorial(n,prime) } }
        h_f_calc = threads.each(&:join)

        # puts "h_f_calc = #{h_f_calc}}"
        # puts "h_f == h_f_calc #{h_f == h_f_calc}"

        # n_f_calc = HenselCode.multiple_decode(primes,1,h_f_calc)

        # puts "n_f_calc = #{n_f_calc}"
        #
        # puts "n_f == n_f_calc = #{n_f == n_f_calc}"

        # n_f_calc.to_i
        10
      end

     def self.mod_factorial(n,p)
       result = n.clone
       while true
         puts "result = #{result}"
         puts "n = #{n}"
         puts "#{(result * (n - 1)) % p} = (#{result} * (#{n - 1})) % #{p}\n\n"
         result = (result * (n - 1)) % p
         n -= 1
         break if n == 1

       end
       result
     end

     def self.fibonacci(n)
       (((1 + Math.sqrt(5))**n - (1 - Math.sqrt(5))**n)/(2**n * Math.sqrt(5))).round(2)
     end

     def self.analyse_prime(prime)
       bn = Integer.sqrt(prime/2) # N
       pi = bn + 1 # positive integers
       ni = bn # negative integers
       ti = pi + ni # total integers
       ff = prime - ti

       codes = (0..prime-1).to_a
       ff_set = codes.map{|c| HenselCode.decode(prime,1,c)}
       ld = ff_set.map{|f| f.denominator}.max

       # fs = ff > 1 ? Integer.sqrt(ff) : "-"
       # fs2 = ff > 1 ? Integer.sqrt((ff+1)/2) : "-"
       # tis = ti > 1 ? Integer.sqrt(ti) : "-"
       # phi_prime = pribn =me - 1
       # phi_prime_sqrt = Integer.sqrt(phi_prime)
       # phi_prime_sqrt2 = Integer.sqrt(phi_prime/2)

       # ldc = 1 + (prime - (bn + 1)) / (prime - (prime - (bn + 1)))
       ldc = ((-bn + prime - 1) / (bn + 1)) + 1

       puts ""
       puts "prime = #{prime}"
       puts "bn = #{bn}"
       puts "pi = #{pi}"
       puts "ni = #{ni}"
       puts "ti = #{ti}"
       puts "ff = #{ff}"
       puts "ld = #{ld}"
       puts "ldc = #{ldc}"
       # puts "fs = #{fs}"
       # puts "fs2 = #{fs2}"
       # puts "tis = #{tis}"
       # puts "phi_prime_sqrt = #{phi_prime_sqrt}"
       # puts "phi_prime_sqrt2 = #{phi_prime_sqrt2}"
       puts ""
     end

     def self.analyse_primes(primes)
       primes.each do |prime|
         analyse_prime(prime)
       end
     end

     def self.convergents(p,r,h)
       a = [p**r, h]
       y = [0, 1]
       i = 1

       fractions = []

       c = (-1)**(i+1) * a[i]
       d = y[i]

       fractions << Rational(c,d)

       while a[i] > 0 # Integer.sqrt((p**r)/2)
         q = a[i-1] / a[i]
         a << (a[i-1] - q * a[i])
         y << (y[i-1] + q * y[i])
         i += 1

         c = (-1)**(i+1) * a[i]
         d = y[i]

         fractions << Rational(c,d)
       end

       fractions
     end

     def self.get_farey_fractions(p,r)
       codes = (0..p**r-1)
       ff = codes.map do |code|
         if code % p == 0
           s = code == 0 ? 1 : code / p
           HenselCode.decode(p,r,code / p) * Rational(1,s*p) * (-1)**(pi(p**r,code).size - 1)
         else
           HenselCode.decode(p,r,code)
         end
       end
       ff
     end

     def self.get_codes(p,r)
       ff = get_farey_fractions(p,r)
       codes = []

       ff.each do |f|
         if f.denominator >= p && f.denominator % p == 0
           s = f.denominator / p
           codes << (HenselCode.encode(p,r,f / Rational(1,3)) * s*p) % p**r
         else
           codes << HenselCode.encode(p,r,f)
         end
       end

       codes
     end

     def self.pi(x,y)
      diffs = [x,y]
      n = Integer.sqrt(x/2)
      while y > n
        diffs << (x - y) % y
        x_ = x
        y_ = y
        x = y
        y = (x_ - y_) % y_
      end
      diffs
    end



    def self.ff_experiment(p,r)
      n = Integer.sqrt(p**r/2)
      n_ = p**r/(n + 1)

      puts "n = #{n}"
      puts "n_ = #{n_}"

      positive_numerators = (0..n).to_a
      positive_denominators = (1..n_).to_a

      negative_numerators = positive_numerators.map{|n| n * (-1)}
      negative_denominators = positive_denominators.map{|n| n * (-1)}

      puts "positive_numerators = #{positive_numerators}"
      puts "positive_denominators = #{positive_denominators}"

      puts "negative_numerators = #{negative_numerators}"
      puts "negative_denominators = #{negative_denominators}"

      numerators = positive_numerators + negative_numerators
      denominators = positive_denominators + negative_denominators

      puts "numerators = #{numerators}"
      puts "denominators = #{denominators}"

      ff = numerators.product(denominators).map{|n| Rational(n[0],n[1])}.uniq

      puts "ff = #{ff}"
      puts "ff.size = #{ff.size}"

      # hensel_codes = get_codes(p,r)
      #
      # puts "hensel_codes = #{hensel_codes}"

      nil
    end

    def self.analyze_k(p)
      codes = (0..p-1).to_a
      bb = Integer.sqrt(p/2)
      # ff = codes.map{|c| HenselCode.decode(p,1,c)}
      ks = codes.map do |h|
        f = HenselCode.decode(p,1,h)
        a = f.numerator
        b = f.denominator
        Rational(a - b * h,p)
      end

      puts "p = #{p}, ks.uniq.size = #{ks.uniq.size}"
      puts "ks.select{|k| k.numerator.abs.bit_length == bb.bit_length}.size = #{ks.select{|k| k.numerator.abs.bit_length == bb.bit_length}.size}"
      # ks
      nil
    end

    def self.select_alpha(p1,p2,p3,p4,m,rounds)
      bb = Integer.sqrt(p4/2)
      c = nil
      k = nil
      ks = []
      rounds.times do
        s2 = random_number(p2.bit_length-1)
        s3 = random_number(p3.bit_length-1)
        alpha = HenselCode.multiple_decode([p1,p2,p3],1,[s2,s3])
        a = alpha.numerator
        b = alpha.denominator
        c = HenselCode.encode(p4,1,alpha)
        k = (b*c - a)/p4
        ks << k
        # break if k > (p4/(2*bb+1))
      end
      # puts "k.bit_lengh = #{k.bit_length}"
      ks
    end

    def self.paillier(m1,m2)
      p = 67
      q = 71
      n = p * q
      gamma = (p - 1).lcm(q - 1)
      g = rand(1..n**2)
      l_g = Tools.mod_inverse((Tools.modular_pow(g,gamma,n**2) - 1)/n,n)

      r1 = rand(1..n)
      r2 = rand(1..n)

      c1 = (Tools.modular_pow(g,m1,n**2) * Tools.modular_pow(r1,n,n**2)) % n**2
      c2 = (Tools.modular_pow(g,m2,n**2) * Tools.modular_pow(r2,n,n**2)) % n**2

      puts "p = #{p}"
      puts "q = #{q}"
      puts "n = #{n}"
      puts "n^{2} = #{n**2}"
      puts "\\gamma = #{gamma}"
      puts "g = #{g}"
      puts "r1 = #{r1}"
      puts "r2 = #{r2}"

      puts "c1 = #{c1}"
      puts "c2 = #{c2}\n\n"

      c1_plus_c2 = (c1 * c2) % n**2

      puts "c1_plus_c2 = #{c1_plus_c2}\n\n"

      mr1 = (((Tools.modular_pow(c1,gamma,n**2) - 1)/n) * l_g) % n
      mr2 = (((Tools.modular_pow(c2,gamma,n**2) - 1)/n) * l_g) % n

      puts "mr1 = #{mr1}"
      puts "mr2 = #{mr2}\n\n"

      mr1_plus_mr2 = (((Tools.modular_pow(c1_plus_c2,gamma,n**2) - 1)/n) * l_g) % n

      puts "mr1_plus_mr2 = #{mr1_plus_mr2}\n\n"
    end

    def self.configuration(l,d,r)
      p1_p2_p3_bits = l
      p4_p5_bit = (6 * l * r - 2 * l) * d
      g_bits = 4*l + 2 * d * (6 * l * r - 2 * l)

      puts "l = #{l}"
      puts "d = #{d}"
      puts "r = #{r}"
      puts "p1_p2_p3_bits = #{p1_p2_p3_bits}"
      puts "p4_p5_bit = #{p4_p5_bit}"
      puts "g_bits = #{g_bits}\n\n"

      nil
    end

    def self.test_correctness(m,r,p1,p2,p3,p4,p5,s)
      g = p1**2 * p2 * p3 * p4 * p5
      c = nil
      # beginning of encrypt
      s.each_slice(4).each_with_index do |s_,i|
        alpha = HenselCode.multiple_decode(
          [p1**2,p2,p3],1,
          [m,s_[0],s_[1]]
        )

        beta = HenselCode.multiple_decode(
          [p1**2,p2,p3],1,
          [1,s_[2],s_[3]]
        )

        zeta = alpha * beta

        puts "step 1"

        if i == 0
          c = (HenselCode.encode(p4,1,alpha) * HenselCode.encode(p4,1,beta)) % g
          puts "step 2"
        else
          c = (c * HenselCode.encode(p4,1,alpha) * HenselCode.encode(p4,1,beta) * HenselCode.encode(p4,1,alpha**(-1))) % g
          puts "step +3"
        end
      end
      c
      # end of encrypt

      puts "m = #{m}\n\n"
      puts "c = #{c}\n\n"

      # beginning of decrypt
      alpha = HenselCode.decode(p4,1,c)
      mr = HenselCode.encode(p1**2,1,alpha)
      # end of decrypt

      puts "mr = #{mr}\n\n"

      nil
    end

    def self.number_to_qubit(n)
      a2 = n
      a3 = random_number(7)
      a4 = random_number(8)
      a5 = random_number(7)
      a6 = random_number(11)
      a7 = random_number(8)
      a8 = random_number(9)

      # % rules
      # % a6 > a5 * a8
      # % a8 > a7

      numerator = (a2 * Math.sqrt(-((a7**2 - a8**2) * a6**2 + a5**2*a8**2) * a4**2 - a3**2 * a6**2 * a8**2))
      denominator = (a4 * a6 * a8)

      a1 = Rational(numerator,denominator);

      z1 = Complex(Rational(a1,a2),Rational(a3,a4));
      z2 = Complex(Rational(a5,a6),Rational(a7,a8));

      q = [z1, z2]
    end

    def self.qubit_to_number(q)
      z1 = q[0]
      z2 = q[1]

      a1 = z1.real.numerator
      a2 = z1.real.denominator
      a3 = z1.imag.numerator
      a4 = z1.imag.denominator
      a5 = z2.real.numerator
      a6 = z2.real.denominator
      a7 = z2.imag.numerator
      a8 = z2.imag.denominator

      # puts "=> #{-((a7**2 - a8**2) * a6**2 + a5**2*a8**2) * a4**2 - a3**2 * a6**2 * a8**2}"

      x = (a2 * Math.sqrt(-((a7**2 - a8**2) * a6**2 + a5**2*a8**2) * a4**2 - a3**2 * a6**2 * a8**2))
      y = (a4 * a6 * a8)

      # puts "x = #{x}"
      #
      # puts "=> #{y**2 * (- a5**2/a6**2 - a7**2/a8**2 + 1) - a3**2 * a6**2 * a8**2}"

      n = x / Math.sqrt(y**2 * (- a5**2/a6**2 - a7**2/a8**2 + 1) - a3**2 * a6**2 * a8**2)
    end

end
