class Gen
    attr_accessor :l, :d, :r, :p1, :p2, :p3, :p4, :p5, :g

    def initialize(l)
        @l = l
        @d = 5 # depth
        @r = 4
        l_primes = nil

        # while true
        #   l_primes = Array.new(3){ Tools.random_prime(@l) }
        #   break if l_primes.uniq.size == 3
        # end
        #
        # @p1 = l_primes[0]
        # @p2 = l_primes[1]
        # @p3 = l_primes[2]

        @p1 = Tools.random_prime(@l)
        @p2 = Tools.random_prime(@l)
        @p3 = Tools.random_prime(@l)

        @p4 = Tools.random_prime((6 * @l * @r - 2 * @l) * @d)
        # @p4 = Tools.random_prime((6 * @l * @r + 4 * @l) * @d)
        # @p4 = Tools.random_prime((12 * @l * @r - 4* @l) * @d)
        # @p4 = Tools.random_prime(3 * @r * (@d + 3) * @l)
        @p5 = Tools.random_prime(@p4.bit_length)

        @g = @p1 * @p2 * @p3 * @p4 * @p5
    end

end
