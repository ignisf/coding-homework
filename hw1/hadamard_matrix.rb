#UTF-8

require 'matrix'

class HadamardMatrix
  H1 = Matrix[[1]]
  H2 = Matrix[[1, 1],[1,-1]]
  H8 =Matrix[[1, 1, 1, 1, 1, 1, 1, 1],
             [1,-1, 1, 1,-1, 1,-1,-1],
             [1,-1,-1, 1, 1,-1, 1,-1],
             [1,-1,-1,-1, 1, 1,-1, 1],
             [1, 1,-1,-1,-1, 1, 1,-1],
             [1,-1, 1,-1,-1,-1, 1, 1],
             [1, 1,-1, 1,-1,-1,-1, 1],
             [1, 1, 1,-1, 1,-1,-1,-1]]
  
  def HadamardMatrix.paley(order)
    raise "The given order #{order} is not valid" unless is_valid order
    return H1 if order == 1
    return H2 if order == 2
    expand Q(order-1) - Matrix.I(order-1)
  end
  
  def HadamardMatrix.sylvester(order)
    raise "The given order #{order} is not valid" unless is_valid order
    return H1 if order == 1
    return H2 if order == 2
    H8
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
  def self.Q(p)
    Matrix.build(p, p) do |i, j|
      chi(j - i, p)
    end
  end
  def self.chi(a, p)
    remainder = a.divmod(p)[1]
    return  0 if remainder == 0
    return  1 if (remainder & (remainder - 1)) == 0
    return -1
  end
  def self.expand(matrix)
    rows = matrix.to_a
    rows.each {|row| row = row.to_a.insert(0, 1)}
    rows.insert 0, Array.new(matrix.row_size + 1, 1)
    Matrix.rows rows
  end
end
