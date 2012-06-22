module Math
  def Math.factorial(n)
    1.upto(n).inject(1) {|result, element| result * element}
  end
  def Math.choose(n, k)
    return 0 if k > n
    Rational(factorial(n), (factorial(k) * factorial(n-k)))
  end
end

module Statistics
  def Statistics.mode(array)
    array.group_by {|value| value}.values.max_by(&:size).first
  end
end

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
    result = []
    # Main loop -- decreasing the order of the code
    code.r.downto(0) do |order|
      # The number of symbols of the information vector that we will be able to
      # calculate from this order.
      symbols = Math.choose(code.m, order).to_i

      # The number of bits of the vector per checksum for this order
      monomials = 2**order

      # The number of checksums per symbol for this order
      checksums = vector.size / monomials

      symbols.downto(1) do |symbol|
        # Offset of the first bit of the vector that is used in the sum
        offset = 0

        # Distance between the bits of the vector used in the sums
        distance = 2**(symbols - symbol)

        # The size of a block of checksums
        block_size = monomials * distance

        # The number of blocks of checksums for this symbol
        blocks = vector.size / block_size

        sums = []
        blocks.times do |block|
          distance.times do
            sum = 0
            monomials.times do |monomial|
              sum ^= vector[offset + monomial*distance]
            end
            sums << sum
            offset += 1
          end
          offset = block * block_size
        end
        p sums
        result << Statistics.mode(sums)
      end
      vector = adjust(vector, symbols, order)
    end
    Vector.elements result.reverse.map {|element| element % 2}
  end

  def adjust(vector, coefficients, power)
    number = Math.choose(@code.m, power).to_i
    offset = 0.upto(power).inject(0) do |result, k|
      result+= Math.choose(@code.m, k)
    end.to_i

    vector = Vector.elements vector
    number.times do |index|
      vector = vector + code.matrix.row(offset - 1 - index) * coefficients[index]
    end
    vector.map {|element| element % 2}
  end

  def decode_matrix(matrix)
    matrix.to_a.map {|vector| decode_vector vector}
  end
end