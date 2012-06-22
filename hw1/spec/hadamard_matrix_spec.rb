require 'rspec'
require './hadamard_matrix.rb'
require 'matrix'

shared_examples_for "a Hadamard matrix constructor" do
  let (:hadamard) { create_instance.call size }
  let (:size) { reference.row_size }
  let (:valid_size)   {[ 1, 2, 4, 8,12,16]}
  let (:invalid_size) {[-2, 0, 3, 5, 6,10]}
  let (:reference) do
    Matrix[[1, 1, 1, 1, 1, 1, 1, 1],
           [1,-1, 1, 1,-1, 1,-1,-1],
           [1,-1,-1, 1, 1,-1, 1,-1],
           [1,-1,-1,-1, 1, 1,-1, 1],
           [1, 1,-1,-1,-1, 1, 1,-1],
           [1,-1, 1,-1,-1,-1, 1, 1],
           [1, 1,-1, 1,-1,-1,-1, 1],
           [1, 1, 1,-1, 1,-1,-1,-1]]
  end
  
  context "when passed an invalid order" do
    it 'raises an error' do
      invalid_size.each do |order|
        expect { create_instance.call order }.to raise_error
      end
    end
  end
  
  context "when passed a valid order" do
    it 'does not raise an error' do
      valid_size.each do |order|
        expect { create_instance.call order }.to_not raise_error
      end
    end
    it 'constructs a matrix' do
      hadamard.should be_a Matrix
    end
    
    it 'constructs a square matrix' do
      hadamard.square?.should be_true
    end
    
    it 'constructs a matrix that contains only 1s and -1s' do
      hadamard.all? {|value| value**2 == 1}.should be_true
    end
    
    it 'constructs a matrix that contains only mutually orthogonal rows' do
      order = hadamard.row_size
      (hadamard * hadamard.transpose).should eq Matrix.scalar(order, order)
    end
    
    it 'constructs a matrix that matches the given reference Hadamard matrix' do
      hadamard.should eq reference
    end
  end

end

describe HadamardMatrix do
  it 'should not be instantiated' do
    HadamardMatrix.new.should raise_error
  end
  
  describe '#paley' do
    let (:create_instance) {Proc.new {|n| HadamardMatrix.paley n}}
    it_behaves_like "a Hadamard matrix constructor"
  end
  
  describe '#duplicate_order' do
    let (:create_instance) {Proc.new {|n| HadamardMatrix.duplicate_order n}}
    it_behaves_like "a Hadamard matrix constructor"
  end
end
