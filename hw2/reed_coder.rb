class ReedCoder
  attr_reader :code

  def initialize(code)
    @code = code
  end

  def encode_matrix(input)
    input.to_a.map {|vector| encode_vector vector}
  end

  def encode_vector(vector)
    result = Matrix.row_vector(vector) * code.matrix
    result.row(0).map {|element| element % 2}
  end
end