#UTF-8

require 'matrix'
require 'prime'

class HadamardMatrix
  H1 = Matrix[[1]]
  H2 = Matrix[[1, 1],[1,-1]]

  def HadamardMatrix.paley(order)
    raise "The given order #{order} is not valid" unless is_valid order
    return H1 if order == 1
    return H2 if order == 2

    raise "The given order #{order} is not valid" unless Prime.prime? order - 1
    p = order - 1

    expand Q(p) - Matrix.I(p)
  end
  
  def HadamardMatrix.sylvester(order)
    raise "The given order #{order} is not valid" unless is_valid order
    raise "The given order #{order} is not valid" unless is_square? order
    return H1 if order == 1
    return H2 if order == 2
    lower_order = sylvester(order/2)
    parent1 = parent2 = parent3 = lower_order.to_a
    parent4   = (-1 * lower_order).to_a
    daughter = []
    parent1.each_index {|index| daughter << parent1[index] + parent2[index]}
    parent3.each_index {|index| daughter << parent3[index] + parent4[index]}
    Matrix.rows(daughter)
  end
  
  private
  def initialize
  end
  def HadamardMatrix.is_valid(order)
    return false if !order.integer?
    return false if order <= 0
    return true  if order <= 2 
    return true  if order.divmod(4)[1] == 0  
    return false
  end
  def self.quadratic(p)
    Array.new(p/2) {|index| ((index+1)**2).divmod(p)[1] }
  end
  def self.is_square?(number)
    (number & (number - 1)) == 0
  end
  def self.Q(p)
    quadratic_remainders = quadratic p
    chi = ->(a) do 
      quotient, remainder = a.divmod(p)
      return  0 if remainder == 0
      return  1 if quadratic_remainders.include? remainder
      return -1
    end
    Matrix.build(p, p) {|i, j| chi.(j - i)}
  end

  def self.expand(matrix)
    rows = matrix.to_a.each {|row| row.unshift 1 }
    rows.unshift Array.new(matrix.row_size + 1, 1)
    Matrix.rows rows
  end
end
