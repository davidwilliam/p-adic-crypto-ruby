require './p-adic-crypto'
require 'benchmark'

# bit_size = 10
# numbers = []
# samples = 10
#
# samples.times do |i|
#   numbers << Tools.random_number(bit_size + i)
# end
#
# puts "numbers = #{numbers}"
#
# Benchmark.bm do |x|
#   numbers.each do |n|
#     x.report("n = #{n}") { Tools.factorial(n) }
#   end
# end

Benchmark.bm do |x|
  x.report{10**2 + 13**3 + 15**4 + 16**5 }
  x.report{10**6 + 13**7 + 15**8 + 16**9 }
  x.report{10**10 + 13**11 + 15**12 + 16**13 }
  x.report{10**14 + 13**15 + 15**16 + 16**17 }
  x.report{10**18 + 13**19 + 15**20 + 16**21 }
end

# SAVED RESULTS

# numbers = [854, 1558, 3119, 5134, 15338, 17790, 54565, 121841, 160117, 360138]
#        user     system      total        real
# n = 854  0.030000   0.000000   0.030000 (  0.004554)
# n = 1558  0.080000   0.010000   0.090000 (  0.016719)
# n = 3119  0.050000   0.000000   0.050000 (  0.012118)
# n = 5134  0.040000   0.000000   0.040000 (  0.008768)
# n = 15338  0.270000   0.030000   0.300000 (  0.089535)
# n = 17790  0.140000   0.030000   0.170000 (  0.111381)
# n = 54565  0.880000   0.170000   1.050000 (  1.005012)
# n = 121841  4.080000   0.240000   4.320000 (  4.234788)
# n = 160117  7.040000   0.040000   7.080000 (  6.972602)
# n = 360138 39.740000   0.210000  39.950000 ( 39.390254)