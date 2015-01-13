module Tuscan
  module Iec60751
    extend self

    def r t90, r0: 100.0, a:3.9083e-03, b:-5.7750e-07, c:-4.1830e-12
      t90 >= 0 ?
        r0*(1 + a*t90 + b*t90**2) :
        r0*(1 + a*t90 + b*t90**2 - 100*c*t90**3 + c*t90**4)
    end
    alias_method :res, :r
    alias_method :resistance, :r

    def t90 r, r0: 100.0, a:3.9083e-03, b:-5.7750e-07, c:-4.1830e-12, err_limit: 1e-4, num_iter: 10
      return 0 if r == r0
      t = t90_approximation r
      return Float::NAN if t.is_a? Complex
      num_iter.times do
        slope = (r - r0) / t
        r_calc = r(t)
        break if (r_calc - r).abs < slope * err_limit
        t -= (r_calc - r) / slope
      end
      t
    end
    alias_method :t, :t90
    alias_method :temperature, :t90

  private
    def t90_approximation r, r0: 100.0, a:3.9083e-03, b:-5.7750e-07, c:-4.1830e-12
      r >= r0 ?
        (-a + (a**2 - 4 * b * (1 - r / r0))**(0.5)) / (2 * b) :
        ((r / r0) - 1) / (a + 100 * b)
    end
  end
end
