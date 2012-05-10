# UTF-8

require 'rspec'
require './reed_coder.rb'
require './rm.rb'

describe ReedCoder do
  let(:information_vector) { Vector[1, 0, 0, 1] }
  let(:code)               { RM.new(1, 3) }
  let(:matrix)             { code.matrix }
  let(:code_vector)        { Vector[1, 0, 1, 0, 1, 0, 1, 0] }
  let(:coder)              { ReedCoder.new code }

  describe 'construction' do
    it 'can be done by passing an RM code' do
      ReedCoder.new code
    end
  end
  describe 'encoding' do
    it 'can be done to an integer'
    it 'can be done to a vector' do
      coder.encode_vector(information_vector).should eq code_vector
    end
    it 'can be done to a matrix' do
      coder.encode_matrix([information_vector, information_vector]).should eq [code_vector, code_vector]
      coder.encode_matrix(Matrix.rows([information_vector, information_vector])).should eq [code_vector, code_vector]
    end
  end
  describe 'decoding' do
    it 'can be done to a vector' do
      coder.decode_vector(code_vector).should eq information_vector
    end
    it 'can be done to a matrix' do
      coder.decode_matrix([code_vector, code_vector]).should eq [information_vector, information_vector]
    end
    it 'should adjust the input vector accordingly' do
      coder.adjust(code_vector, [1, 0, 0], 1).should eq(Vector.elements([1] * 8))
    end
  end
end
