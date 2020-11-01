class Party

  attr_accessor :pid, :name, :a, :b, :add_result, :mul_result

  def initialize(id)
    @pid = id
    @name = "Party-#{id}"
  end

  def add
    @add_result = a + b
  end

  def mul
    @mul_result = a * b
  end
end
