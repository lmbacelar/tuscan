require 'spec_helper'

module Tuscan
  describe Its90 do
    context 'reference funtions' do
      examples = [
        { fixed_point: 'e-H2 Tp', t90: -259.3467, wr: 0.00119007 },
        { fixed_point: 'Ne Tp',   t90: -248.5939, wr: 0.00844974 },
        { fixed_point: 'O2 Tp',   t90: -218.7916, wr: 0.09171804 },
        { fixed_point: 'Ar Tp',   t90: -189.3442, wr: 0.21585975 },
        { fixed_point: 'Hg Tp',   t90:  -38.8344, wr: 0.84414211 },
        { fixed_point: 'H2O Tp',  t90:    0.01,   wr: 1.00000000 },
        { fixed_point: 'Ga Mp',   t90:   29.7646, wr: 1.11813889 },
        { fixed_point: 'In Fp',   t90:  156.5985, wr: 1.60980185 },
        { fixed_point: 'Sn Fp',   t90:  231.9280, wr: 1.89279768 },
        { fixed_point: 'Zn Fp',   t90:  419.5270, wr: 2.56891730 },
        { fixed_point: 'Al Fp',   t90:  660.3230, wr: 3.37600860 },
        { fixed_point: 'Ag Fp',   t90:  961.7800, wr: 4.28642053 }
      ]

      context 'wr computation' do
        examples.each do |example|
          it "complies on #{example[:fixed_point]} fixed point" do
            expect(Its90.wr example[:t90]).to be_within(1e-8).of(example[:wr])
          end
        end

        context 'range validation' do
          t90lo = -274.0
          it "raises RangeError when t90r is #{t90lo} ºC" do
            expect{ Its90.wr t90lo }.to raise_error RangeError
          end

          t90hi = 962.0
          it "raises RangeError when t90r is #{t90hi} ºC" do
            expect{ Its90.wr t90hi }.to raise_error RangeError
          end
        end
      end

      context 't90r computation' do
        examples.each do |example|
          it "complies on #{example[:fixed_point]} fixed point" do
            expect(Its90.t90r example[:wr]).to be_within(0.00013).of(example[:t90])
          end
        end

        context 'range validation' do
          wrlo = -0.1
          it "raises RangeError when wr is #{wrlo}" do
            expect{ Its90.t90r wrlo }.to raise_error RangeError
          end

          wrhi = 4.3
          it "raises RangeError when wr is #{wrhi}" do
            expect{ Its90.t90r wrhi }.to raise_error RangeError
          end
        end
      end


    end

    context 'deviation functions' do
      context 'wdev computation' do
        context 'range 4' do
          # Examples valid for sub-range = 4, a = -1.2579994e-04, b = 1.0678395e-05 as per NIST SP250-81
          sprt = { subrange: 4, a: -1.2579994e-04, b: 1.0678395e-05 }
          examples = [
            { t90: -189.3442, wdev: 0.000111482 },
            { t90: -100.0000, wdev: 0.000053258 },
            { t90:  -38.8344, wdev: 0.000019889 },
            { t90:    0.0000, wdev: 0.000000005 }
          ]

          examples.each do |example|
            it "complies with NIST SP250-81 example on range 4, #{example[:t90]} Celsius" do
              expect(Its90.wdev example[:t90], sprt).to be_within(1e-8).of(example[:wdev])
            end
          end

        end

        context 'range 6' do
          sprt = { subrange: 6, a: -1.6462789e-04, b: -8.4598339e-06, c:  1.8898584e-06 }
          examples = [
            { t90:   0.000, wdev:  0.000000007},
            { t90: 100.000, wdev: -0.000065852},
            { t90: 231.928, wdev: -0.000152378},
            { t90: 419.527, wdev: -0.000271813},
            { t90: 660.323, wdev: -0.000413567}
          ]

          examples.each do |example|
            it "complies with NIST SP250-81 example on range 6, #{example[:t90]} Celsius" do
              expect(Its90.wdev example[:t90], sprt).to be_within(1e-8).of(example[:wdev])
            end
          end
        end

        context 'range validation' do
          examples =
            [ -259.4467..0.01,    -248.5939..0.01,   -218.7916..0.01,
              -189.3442..0.01,          0.0..961.78,       0.0..660.323 ,
                    0.0..419.527 ,      0.0..231.928 ,     0.0..156.5985,
                    0.0..29.7646 , -38.8344..29.7646 ]

          (1..11).each do |subrange|
            context "on a sub-range #{subrange} SPRT" do
              t90lo = examples[subrange-1].min - 1.0
              it "raises RangeError when t90 is #{t90lo} ºC" do
                expect{ Its90.wdev t90lo, subrange: subrange }.to raise_error RangeError
              end

              t90hi = examples[subrange-1].max + 1.0
              it "raises RangeError when t90 is #{t90hi} ºC" do
                expect{ Its90.wdev t90hi, subrange: subrange }.to raise_error RangeError
              end
            end
          end
        end
      end
    end

    context 't90 function' do
      sprt = { rtpw: 25.319871, subrange: 7, a: -1.2134e-04, b: -9.9190e-06 }
      examples = [
        { r: 25.319871, t90:   0.010 },
        { r: 47.922451, t90: 231.928 },
        { r: 65.039218, t90: 419.527 }
      ]

      examples.each do |example|
        it "complies with IPQ cert. 501.20/1241312 range 7, #{example[:t90]} Celsius" do
          expect(Its90.t90 example[:r], sprt).to be_within(0.0001).of(example[:t90])
        end
      end
    end
  end
end
