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

  def decode_vector(vector)
    power = @code.r
    Array.new(power + 1) do |bit| #bit of the word
      p 0
      starts = Array.new(@code.length) {|index| index}
      difference = 2**bit
      monomials = 2**(power - bit)
      #p monomials
      Array.new(@code.length/monomials) do |i| #new sum
        start = starts.shift
        p 1
        Array.new(monomials) do |m| #new monomial

          starts.delete_at(start + m * difference)
          vector[start + m * difference]
          p 2
        end
      end
    end
  end
end