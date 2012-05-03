require 'rspec'
require './rm.rb'
require 'matrix'

describe RM do

  # [16, 11, 4]
  let(:order) { 2 }
  let(:length) { 4 }
  let(:code) { RM.new order, length }

  describe 'construction' do
    it 'raises an error when a code does not exist for the given arguments' do
      # http://en.wikipedia.org/wiki/Reed%E2%80%93Muller_code#Alternative_construction
      # RM(r, m)
      # m >= 0
      # r >= 0
      # r <= m
      expect { RM.new(-1, -1) }.to raise_error
      expect { RM.new(-1,  3) }.to raise_error
      expect { RM.new( 5,  4) }.to raise_error
    end

    it 'cunstructs the generating matrix correctly' do
      rmcode = RM.new(2, 4)
      rmcode.matrix.to_a[9].should eq([0, 0, 0, 0, 0, 1, 0, 1] * 2)

      rmcode = RM.new(3, 4)
      rmcode.matrix.to_a[14].should eq([0, 0, 0, 0, 0, 0, 0, 1] * 2)
    end
  end

  it 'returns its length' do
    code.length.should eq 2**length
    code.length.should eq code.size
  end

  it 'returns its dimension' do
    RM.new(0, 3).dimension.should eq 1
    RM.new(2, 4).dimension.should eq 11
  end

  it 'returns its minimum distance' do
    code.weight.should eq 2 **(length - order)
  end

  it 'returns its standard code notation' do
    code.notation.should eq [code.length, code.dimension, code.weight]
    # p [code.length, code.dimension, code.minimum_distance]
  end

  it 'returns its information rate' do
    RM.new(2,4).information_rate.should eq Rational(11, 16)
    RM.new(1,5).information_rate.should eq Rational(3, 16)
  end

  it 'returns how many errors it can correct' do
    RM.new(2,4).corrects.should eq 1
    RM.new(1,5).corrects.should eq 7
  end

  it 'returns how many errors it can detect' do
    RM.new(2,4).detects.should eq 3
    RM.new(1,5).detects.should eq 15
  end

  it 'calculates the parameters of codes that can correct the passed number of errors' do
    RM.correcting(7, 22).should eq RM.new(2, 6)
  end

  it 'calculates the perameters of codes that can detect the passed number of errors' do
    RM.detecting(7, 15).should eq RM.new(2, 5)
  end
end
