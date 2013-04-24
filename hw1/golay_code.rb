#UTF-8
require './hadamard_matrix.rb'

class GolayCode
  attr_reader :dimension, :matrix, :minimum_distance
  
  def initialize(dimension)
    @dimension = dimension
    @minimum_distance = dimension/2 + 2
    construct_matrix
  end
  
  private
  def construct_matrix
    right = a.collect { |row| row << 1 }
    right.unshift(Array.new(@dimension - 1, 1) << 0)
    left = Matrix.I(@dimension).to_a
    @matrix = Matrix.rows left.zip(right).each {|row| row.flatten!}
  end
  def a
    begin
      hadamard = HadamardMatrix.paley(@dimension).to_a
    rescue
      raise "Invalid dimension"
    end
    hadamard.shift
    hadamard.reverse!.each do |row|
      row.shift
      row.reverse!.collect! do |value|
        if value == -1
          1
        elsif value == 1
          0
        end
      end
    end
  end
end
