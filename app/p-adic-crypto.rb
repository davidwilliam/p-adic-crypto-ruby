class PAdicCrypto

    def self.encrypt(k,m)
        s_bits = k.p1.bit_length
        c = nil

        for i in (1..k.r)
          alpha = HenselCode.multiple_decode(
            [k.p1,k.p2,k.p3],1,
            [m,Tools.random_number(s_bits - 1),Tools.random_number(s_bits - 1)]
          )

          # puts "alpha.a.bit_length = #{alpha.numerator.bit_length}"
          # puts "alpha.b.bit_length = #{alpha.denominator.bit_length}\n\n"

          beta = HenselCode.multiple_decode(
            [k.p1**2,k.p2,k.p3],1,
            [1,Tools.random_number(s_bits - 1),Tools.random_number(s_bits - 1)]
          )

          # puts "beta.a.bit_length = #{beta.numerator.bit_length}"
          # puts "beta.b.bit_length = #{beta.denominator.bit_length}\n\n"

          zeta = alpha * beta

          # puts "zeta.a.bit_length = #{zeta.numerator.bit_length}"
          # puts "zeta.b.bit_length = #{zeta.denominator.bit_length}\n\n"

          if i == 1
            c = (HenselCode.encode(k.p4,1,alpha) * HenselCode.encode(k.p4,1,beta)) % k.g
            # puts "First c = #{c}"
          else
            c = (c * HenselCode.encode(k.p4,1,alpha) * HenselCode.encode(k.p4,1,beta) * HenselCode.encode(k.p4,1,alpha**(-1))) % k.g
            # puts "Second and on c = #{c}"
          end
        end

        c
    end

    def self.decrypt(k,c)
        alpha = HenselCode.decode(k.p4,1,c)
        a = alpha.numerator
        b = alpha.denominator
        k_ = (b * c - a)/k.p4
        # puts "alpha.a.bit_length = #{alpha.numerator.bit_length}"
        # puts "alpha.b.bit_length = #{alpha.denominator.bit_length}"
        # puts "alpha.b.bit_length = #{alpha.denominator.bit_length}"
        # puts "k_.bit_length = #{k_.bit_length}"
        # puts "lambda = #{k.l}"
        # puts "p4.bit_length = #{k.p4.bit_length}"
        # puts "p5.bit_length = #{k.p5.bit_length}"
        # puts "g = #{k.g}\n\n"
        # puts "a = #{a}"
        # puts "b = #{b}"
        # puts "k = #{k_}"
        m = HenselCode.encode(k.p1,1,alpha)
    end

    def self.add(g,c1,c2)
      (c1 + c2) % g
    end

    def self.sub(g,c1,c2)
      (c1 - c2) % g
    end

    def self.mul(g,c1,c2)
      (c1 * c2) % g
    end
end
