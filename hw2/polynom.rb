require 'matrix'

class Polynom
  attr_reader :coefficients, :power, :truth_table

  def Polynom.truth_vector(*vector)
    coefficients = Polynom.get_system(Math.log2(vector.size).to_i)
    constants = Matrix.column_vector vector
    solutions = (coefficients.inverse * constants).map {|e| e.to_int % 2}
    new solutions.column 0
  end

  def Polynom.[](*coefficients)
    new coefficients
  end

  def value_for(vector)
    @truth_table[vector]
  end

  def truth_vector
    Vector.elements @truth_table.values
  end

  private
  def is_pow2?(n)
    n & (n - 1) == 0
  end

  def is_binary?(n)
    n == 1 || n == 0
  end

  def initialize(coefficients, values=nil)
    raise "Please specify 2^n coefficients" if !is_pow2? coefficients.size
    raise "Valid coefficients: 0 or 1" if coefficients.any? {|n| !is_binary? n}

    @power = Math.log2(coefficients.size).to_i
    @coefficients = Vector.elements coefficients
    values = values ? values : Polynom.get_truth_vector(coefficients, @power)
    @truth_table = Hash[*Polynom.arg_table(@power).zip(values).flatten(1)]
  end

  def Polynom.get_combinations(variables, power=nil)
    power = power ? power : variables.size
    Array.new(power) do |key|
      variables.combination(key+1).to_a
    end.flatten(1)
  end

  def Polynom.multiply(variables, power=variables.size)
    combinations = Polynom.get_combinations(variables, power)
    [1] + combinations.map! do |combination|
      combination.reduce(:&)
    end
  end

  def Polynom.arg_table(vars)
    Array.new(2**vars) do |row|
      Array.new(vars) {|column| row[column]}
    end.sort {|a, b| a.count(1) <=> b.count(1)}
  end

  def Polynom.get_system(vars)
    Matrix.rows arg_table(vars).map {|args| multiply(args)}
  end

  def Polynom.get_truth_vector(coefficients, power)
    elements = arg_table(power).map do |values|
      mononoms = Vector.elements(Polynom.multiply values)
      values = mononoms.inner_product(coefficients) % 2
    end
    Vector.elements elements
  end
end