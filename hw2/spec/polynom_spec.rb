require 'rspec'
require './polynom.rb'
require 'matrix'

describe Polynom do
  describe 'construction' do
    it 'can be done by passing a vector of coefficients' do
      Polynom[0, 0, 0, 1].coefficients.should eq Vector[0, 0, 0, 1]
    end
    it 'can be done by passing a truth vector' do
      Polynom.truth_vector(0, 0, 0, 1).coefficients.should eq Vector[0, 0, 0, 1]
    end
  end
  it 'gives you a vector of its coefficients' do
    Polynom[1, 0, 1, 1].coefficients.should eq Vector[1, 0, 1, 1]
  end

  it 'only works with binary coefficients' do
    expect {Polynom[2, 0 , -1, 3]}.to raise_error
  end

  it 'thorws an error when a vector of an incorrect size is given' do
    expect {Polynom.truth_vector([0,0,0])}.to raise_error
  end

  it 'only accepts 2^n coefficients' do
    expect {Polynom[1, 0, 1]}.to raise_error
  end

  it 'returns a correct value when given variables values to substitute with' do
    poly = Polynom[1, 0, 0, 1, 0, 0, 0, 0]
    poly.value_for([0, 0, 0]).should eq 1
    poly.value_for([1, 1, 1]).should eq 0

    poly = Polynom[0, 0, 0, 0, 0, 1, 1, 0]
    poly.value_for([1, 1, 0]).should eq 0
    poly.value_for([1, 0, 1]).should eq 1
    poly.value_for([1, 1, 1]).should eq 0
  end

  it 'can tell its power' do
    Polynom[1, 0, 1, 1].power.should eq 2
  end


  it 'constructs a correct argument table' do
    Polynom.arg_table(3).should eq [[0, 0, 0],
                               [1, 0, 0],
                               [0, 1, 0],
                               [0, 0, 1],
                               [1, 1, 0],
                               [1, 0, 1],
                               [0, 1, 1],
                               [1, 1, 1]]
  end
  
  it 'calculates a truth vector correctly' do
    polynom = Polynom[1, 0, 0, 1]
    polynom.truth_vector.should eq Vector[1, 1, 1, 0]

    polynom = Polynom[0, 0, 0, 0, 0, 1, 1, 0]
    polynom.truth_vector.should eq Vector[0, 0, 0, 0, 0, 1, 1, 0]
  end
end