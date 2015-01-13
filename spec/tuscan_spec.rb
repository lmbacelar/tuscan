require 'spec_helper'

describe Tuscan do
  it 'forwards methods to child modules' do
    expect(Tuscan::Iec60751).to receive(:t).with(r: 101, r0: 100)
    Tuscan.t :iec60751, r: 101, r0: 100
  end
end
