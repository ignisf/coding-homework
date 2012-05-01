require 'matrix'
require './polynom.rb'

class RM
  attr_reader :r, :m, :matrix

  def initialize(r, m)
    raise "r must be >= 0 and m must be >= r" if r < 0 or r > m
    @r, @m = r, m
    calculate_gen_matrix
  end

  def detects
    weight - 1
  end

  def corrects
    (weight - 1)/2
  end

  def information_rate
    Rational(dimension, length)
  end

  def notation
    [length, dimension, weight]
  end

  def length
    2**@m
  end

  def to_s
    "RM(%d, %d)" % [@r, @m]
  end

  alias :size :length

  def dimension
    matrix.row_size
  end

  # Minimum Hamming weight
  def weight
    2 ** (@m-@r)
  end

  def ==(other)
    other.r == @r && other.m == @m
  end

  def RM.detecting(errors, min_dimension)
    difference = Math.log2(errors + 1).ceil
    RM.by_parameters(difference, min_dimension)
  end

  def RM.correcting(errors, min_dimension)
    difference = Math.log2(Rational(1, 2) + errors).ceil + 1
    RM.by_parameters(difference, min_dimension)
  end

  private

  def RM.by_parameters(difference, min_dimension)
    r, m = 0, difference
    begin
      rm = RM.new(r, m)
      if m - r > difference
        r+=1
      else
        r = 0
        m += 1
      end
    end while rm.dimension < min_dimension
    rm
  end

  def calculate_gen_matrix
    arguments = Array.new(2**@m) do |row|
      Array.new(@m) { |column| row[@m - column - 1] }
    end
    columns = arguments.map {|row| Polynom.multiply row, @r}
    @matrix = Matrix.columns columns
  end
end
