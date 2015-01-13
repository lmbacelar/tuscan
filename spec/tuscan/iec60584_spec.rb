require 'spec_helper'

#
# TODO:
#   1. compute inverse of emfr by iterative process (will pass R, B examples)
#   2. get aproximate t90 valid fro -270.0..-200.0 (will pass E, K, N, T examples)
#   3. implement deviation function (polynomial)
#
module Tuscan
  describe Iec60584 do
    context 'reference functions' do
      examples = {
        b: [
          # { emf:  0.000, t90:   0.0 },
          { emf:  0.291, t90: 250.0 },
          { emf:  1.975, t90: 630.0 },
          { emf:  1.981, t90: 631.0 },
          { emf:  5.780, t90:1100.0 },
          { emf: 13.820, t90:1820.0 }
        ],
        c: [
          { emf:  0.000, t90:   0.0 },
          { emf:  1.451, t90: 100.0 },
          { emf: 11.778, t90: 660.0 },
          { emf: 20.066, t90:1100.0 },
          { emf: 29.402, t90:1680.0 },
          { emf: 37.107, t90:2320.0 }
        ],
        e: [
          # { emf: -9.835, t90:-270.0 },
          { emf: -8.825, t90:-200.0 },
          { emf: -5.237, t90:-100.0 },
          { emf:  0.000, t90:   0.0 },
          { emf:  6.319, t90: 100.0 },
          { emf: 49.917, t90: 660.0 },
          { emf: 76.373, t90:1000.0 }
        ],
        j: [
          { emf: -8.095, t90:-210.0 },
          { emf: -4.633, t90:-100.0 },
          { emf:  0.000, t90:   0.0 },
          { emf: 36.675, t90: 660.0 },
          { emf: 43.559, t90: 770.0 },
          { emf: 69.553, t90:1200.0 }
        ],
        k: [
          # { emf: -6.458, t90:-270.0 },
          { emf: -5.891, t90:-200.0 },
          { emf: -3.554, t90:-100.0 },
          { emf:  0.000, t90:   0.0 },
          { emf:  5.206, t90: 127.0 },
          { emf: 27.447, t90: 660.0 },
          { emf: 54.886, t90:1372.0 }
        ],
        n: [
          # { emf: -4.345, t90:-270.0 },
          { emf: -3.990, t90:-200.0 },
          { emf: -2.407, t90:-100.0 },
          { emf:  0.000, t90:   0.0 },
          { emf:  2.774, t90: 100.0 },
          { emf: 22.958, t90: 660.0 },
          { emf: 47.513, t90:1300.0 }
        ],
        r: [
          # { emf: -0.226, t90: -50.0 },
          { emf: -0.123, t90: -25.0 },
          { emf:  0.000, t90:   0.0 },
          { emf:  6.273, t90: 660.0 },
          { emf: 11.850, t90:1100.0 },
          { emf: 21.101, t90:1768.0 }
        ],
        s: [
          { emf: -0.236, t90: -50.0 },
          { emf: -0.127, t90: -25.0 },
          { emf:  0.000, t90:   0.0 },
          { emf:  5.857, t90: 660.0 },
          { emf: 10.757, t90:1100.0 },
          { emf: 18.693, t90:1768.0 }
        ],
        t: [
          # { emf: -6.258, t90:-270.0 },
          { emf: -5.603, t90:-200.0 },
          { emf: -3.379, t90:-100.0 },
          { emf:  0.000, t90:   0.0 },
          { emf:  4.279, t90: 100.0 },
          { emf:  9.288, t90: 200.0 },
          { emf: 20.872, t90: 400.0 }
        ]
      }

      context 'emfr computation' do
        %i{ b c e j k n r s t }.each do |type|
          context "on a type #{type.upcase} thermocouple" do
            examples[type].each do |example|
              it "yields #{example[:emf]} mV when t90 equals #{example[:t90]} ºC" do
                expect(Iec60584.emfr(example[:t90], type)).to be_within(1e-3).of(example[:emf])
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
                expect(Iec60584.t90r(example[:emf], type)).to be_within(0.1).of(example[:t90])
              end
            end
          end
        end
      end
    end
  end
end
