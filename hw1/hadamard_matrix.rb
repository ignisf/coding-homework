#UTF-8

require 'matrix'

class HadamardMatrix
  def HadamardMatrix.paley(order)
    raise "The given order #{order} is not valid" unless is_valid order
  end
  
  def HadamardMatrix.duplicate_order(order)
    raise "The given order #{order} is not valid" unless is_valid order
  end
  
  private
  def initialize
  end
  def HadamardMatrix.is_valid(order)
    return false if !order.integer?
    return false if order <= 0
    return true  if order <= 2 
    return true  if Rational(order, 4).denominator == 1  
    return false
  end
end
