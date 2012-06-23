require 'rspec'
require './hadamard_matrix.rb'
require 'matrix'

shared_examples_for "a Hadamard matrix constructor" do
  let (:ref_order) { reference.row_size }
  let (:hadamard) { create_instance.call ref_order }
  let (:samples) do
    valid_order.collect {|order| create_instance.call(order)}
  end
  
  context "when passed an invalid order" do
    it 'raises an error' do
      invalid_order.each do |order|
        expect { create_instance.call order }.to raise_error
      end
    end
  end
  
  context "when passed a valid order" do
    it 'does not raise an error' do
      valid_order.each do |order|
        expect { create_instance.call order }.to_not raise_error
      end
    end
    it 'constructs a matrix' do
      samples.each {|sample| sample.should be_a Matrix}
    end
    
    it 'constructs a square matrix' do
      samples.each {|sample| sample.square?.should be_true}
    end
    
    it 'constructs a matrix that contains only 1s and -1s' do
      samples.each {|sample| sample.all? {|value| value**2 == 1}.should be_true}
    end
    
    it 'constructs a matrix that contains only mutually orthogonal rows' do
      samples.each do |sample|
        order = sample.row_size
        (sample * sample.transpose).should eq Matrix.scalar(order, order)
      end
    end
    
    it 'constructs a matrix that matches the given reference Hadamard matrix' do
      hadamard.should eq reference
    end
  end

end

describe HadamardMatrix do
  it 'cannot be instantiated' do
    HadamardMatrix.new.should raise_error
  end
  
  describe '#paley' do
    let (:valid_order)   {[ 1, 2, 4, 8,12]}
    let (:invalid_order) {[-2, 0, 3, 5, 6,10,14,16,28]}
    let (:create_instance) {Proc.new {|n| HadamardMatrix.paley n}}
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
    
    it_behaves_like "a Hadamard matrix constructor"
  end
  
  describe '#sylvester' do
    let (:valid_order)   {[ 1, 2, 4, 8,16,32]}
    let (:invalid_order) {[-2, 0, 3, 5, 6,10,12,14]}
    let (:create_instance) {Proc.new {|n| HadamardMatrix.sylvester n}}
    let (:reference) do
      Matrix[[1, 1, 1, 1, 1, 1, 1, 1],
             [1,-1, 1,-1, 1,-1, 1,-1],
             [1, 1,-1,-1, 1, 1,-1,-1],
             [1,-1,-1, 1, 1,-1,-1, 1],
             [1, 1, 1, 1,-1,-1,-1,-1],
             [1,-1, 1,-1,-1, 1,-1, 1],
             [1, 1,-1,-1,-1,-1, 1, 1],
             [1,-1,-1, 1,-1, 1, 1,-1]]
    end
    it_behaves_like "a Hadamard matrix constructor"
  end
end
