require 'spec_helper'

module Tuscan
  describe Iec60751 do
    examples = [ { r:  18.5201, t90: -200.0000 },
                 { r:  60.2558, t90: -100.0000 },
                 { r: 100.0000, t90:    0.0000 },
                 { r: 247.0920, t90:  400.0000 },
                 { r: 390.4811, t90:  850.0000 } ]

    context 'resistance computation' do
      context 'standard coefficients' do
        examples.each do |example|
          it "yields #{example[:r]} Ohm when t90 equals #{example[:t90]} Celsius" do
            expect(Iec60751.r example[:t90]).to be_within(1e-4).of(example[:r])
          end
        end
      end

      context 'non-standard coefficients' do
        it 'yields 101.0 Ohm when temperature equals 0.0 Celsius for r0 = 101.0 Ohm' do
          expect(Iec60751.r 0, r0: 101.0).to be_within(1e-4).of(101)
        end
      end

      it 'raises RangeError when t90 is out of range' do
        expect{ Iec60751.r -201.0 }.to raise_error RangeError
        expect{ Iec60751.r  851.0 }.to raise_error RangeError
      end
    end

    context 'temperature computation' do
      context 'standard coefficients' do
        examples.each do |example|
          it "yields #{example[:t90]} Celius when resistance equals #{example[:r]} Ohm" do
            expect(Iec60751.t90 example[:r]).to be_within(1e-4).of(example[:t90])
          end
        end
      end

      context 'non-standard coefficients' do
        it 'yields 0.0 Celsius when resistance equals 101.0 Ohm on a FUNCTION with r0 = 101.0 Ohm' do
          expect(Iec60751.t90 101, r0: 101.0).to be_within(1e-4).of(0)
        end
      end

      it 'raises RangeError when r is out of range' do
        expect{ Iec60751.t90  18.0 }.to raise_error RangeError
        expect{ Iec60751.t90 391.0 }.to raise_error RangeError
      end
    end
  end
end
