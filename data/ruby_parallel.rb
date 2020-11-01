require 'benchmark'
require './p-adic-crypto'

numbers = 10.times{|i| Tools.random_number(30 + i) }

n = Tools.random_number(17)

primes = Prime.first(n)

puts Benchmark.measure {
  Tools.factorial(n)
}

puts Benchmark.measure {
  Tools.p_adic_factorial(n,primes)
}

# results = Parallel.map(['a','b','c'], in_processes: 3) { |one_letter| ... }
#
# # 3 Threads -> finished after 1 run
# results = Parallel.map(['a','b','c'], in_threads: 3) { |one_letter| ... }

# 10.times do |i|
#   puts Benchmark.measure do
#     puts "--- regular version -- "
#     Tools.factorial(numbers[i])
#   end
#
#   puts Benchmark.measure do
#     puts "--- p-adic version -- "
#     Tools.p_adic_factorial(numbers[i])
#   end
#
# end
