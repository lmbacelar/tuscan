require 'spec_helper'

#
# TODO:
#   1. compute better t90_guess for 50..250 ºC to allow extension of T90_RANGE down to 50ºC
#
module Tuscan
  describe Iec60584 do
    context 'reference functions' do
      err = 1e-3
      num = 10
      examples = {
        b: [
          { emf:  0.006197, t90:  60.0 },
          { emf:  0.291279, t90: 250.0 },
          { emf:  1.974546, t90: 630.0 },
          { emf:  1.980771, t90: 631.0 },
          { emf:  5.779517, t90:1100.0 },
          { emf: 13.820279, t90:1820.0 }
        ],
        c: [
          { emf: -0.000311, t90:   0.0 },
          { emf:  1.450711, t90: 100.0 },
          { emf: 11.778492, t90: 660.0 },
          { emf: 20.066070, t90:1100.0 },
          { emf: 29.402461, t90:1680.0 },
          { emf: 37.106593, t90:2320.0 }
        ],
        e: [
          { emf: -9.834951, t90:-270.0 },
          { emf: -8.824581, t90:-200.0 },
          { emf: -5.237184, t90:-100.0 },
          { emf:  0.000000, t90:   0.0 },
          { emf:  6.318930, t90: 100.0 },
          { emf: 49.917224, t90: 660.0 },
          { emf: 76.372826, t90:1000.0 }
        ],
        j: [
          { emf: -8.095380, t90:-210.0 },
          { emf: -4.632524, t90:-100.0 },
          { emf:  0.000000, t90:   0.0 },
          { emf: 36.675405, t90: 660.0 },
          { emf: 43.559497, t90: 770.0 },
          { emf: 69.553180, t90:1200.0 }
        ],
        k: [
          { emf: -6.457738, t90:-270.0 },
          { emf: -5.891404, t90:-200.0 },
          { emf: -3.553631, t90:-100.0 },
          { emf:  0.000000, t90:   0.0 },
          { emf:  5.206093, t90: 127.0 },
          { emf: 27.447068, t90: 660.0 },
          { emf: 54.886364, t90:1372.0 }
        ],
        n: [
          { emf: -4.3451354, t90:-270.0 },
          { emf: -3.990376, t90:-200.0 },
          { emf: -2.406811, t90:-100.0 },
          { emf:  0.000000, t90:   0.0 },
          { emf:  2.774124, t90: 100.0 },
          { emf: 22.957828, t90: 660.0 },
          { emf: 47.512772, t90:1300.0 }
        ],
        r: [
          { emf: -0.226465, t90: -50.0 },
          { emf: -0.123155, t90: -25.0 },
          { emf:  0.000000, t90:   0.0 },
          { emf:  6.273327, t90: 660.0 },
          { emf: 11.849642, t90:1100.0 },
          { emf: 21.101477, t90:1768.0 }
        ],
        s: [
          { emf: -0.235555, t90: -50.0 },
          { emf: -0.126831, t90: -25.0 },
          { emf:  0.000000, t90:   0.0 },
          { emf:  5.856769, t90: 660.0 },
          { emf: 10.756545, t90:1100.0 },
          { emf: 18.692510, t90:1768.0 }
        ],
        t: [
          { emf: -6.257505, t90:-270.0 },
          { emf: -5.602961, t90:-200.0 },
          { emf: -3.378582, t90:-100.0 },
          { emf:  0.000000, t90:   0.0 },
          { emf:  4.278519, t90: 100.0 },
          { emf:  9.288102, t90: 200.0 },
          { emf: 20.871970, t90: 400.0 }
        ]
      }

      context 'emfr computation' do
        %i{ b c e j k n r s t }.each do |type|
          context "on a type #{type.upcase} thermocouple" do
            examples[type].each do |example|
              it "yields #{example[:emf]} mV when t90 equals #{example[:t90]} ºC" do
                expect(Iec60584.emfr(example[:t90], type)).to be_within(1e-6).of(example[:emf])
              end
            end
          end
        end
      end

      context 't90r computation' do
        %i{ b e j k n r s t }.each do |type|
          context "on a type #{type.upcase} thermocouple" do
            examples[type].each do |example|
              it "yields #{example[:t90]} ºC when emf equals #{example[:emf]} mV" do
                expect(Iec60584.t90r(example[:emf], type, err, num)).to be_within(1e-3).of(example[:t90])
              end
            end
          end
        end
      end

      context 'range validation' do
        %i{ b c e j k n r s t }.each do |type|
          context "on a type #{type.upcase} thermocouple" do
            t90lo = examples[type].first[:t90] - 1.0
            it "raises RangeError when t90 is #{t90lo} ºC" do
              expect{ Iec60584.emfr t90lo, type }.to raise_error RangeError
            end

            t90hi = examples[type].last[:t90] + 1.0
            it "raises RangeError when t90 is #{t90hi} ºC" do
              expect{ Iec60584.emfr t90hi, type }.to raise_error RangeError
            end
          end
        end
      end
    end

    context 'deviation functions' do
      context 'emfdev computation' do
        it 'delegates to Polynomial' do
          expect(Polynomial).to receive(:new).with(1, 2, 3, 4).and_call_original
          Iec60584.emfdev 0, 1, 2, 3, 4
        end

        it 'calls Polynomial#solve_for' do
          expect_any_instance_of(Polynomial).to receive(:solve_for).with(0)
          Iec60584.emfdev 0, 1, 2, 3, 4
        end
      end
    end

    context 'non-standard coefficients' do
      tc = { type: :r, a: 0, b: -1.39363e-05, c: 3.75578e-08, d: -2.17624e-11 }
      examples = [
        { emf:  3.6105, t90:  419.527 },
        { emf: 10.0054, t90:  961.78  },
        { emf: 11.6417, t90: 1084.62  }
      ]

      context 't90 function' do
        examples.each do |example|
          it "complies with NPL cert. 2014040275/1/PM03, #{example[:emf]} mV => #{example[:t90]} ºC" do
            expect(Iec60584.t90 example[:emf], tc).to be_within(0.01).of(example[:t90])
          end
        end
      end

      context 'emf function' do
        examples.each do |example|
          it "complies with NPL cert. 2014040275/1/PM03, #{example[:t90]} ºC => #{example[:emf]} mV" do
            expect(Iec60584.emf example[:t90], tc).to be_within(0.0001).of(example[:emf])
          end
        end
      end
    end
  end
end
