require 'rical'

module Tuscan
  module Iec60751
    R0 = 100.0
    A  =   3.9083e-03
    B  =  -5.7750e-07
    C  =  -4.1830e-12

    extend self

    def r t90, r0: R0, a: A, b: B, c: C
      t90 >= 0 ?
        r0*(1 + a*t90 + b*t90**2) :
        r0*(1 + a*t90 + b*t90**2 - 100*c*t90**3 + c*t90**4)
    end
    alias_method :res, :r
    alias_method :resistance, :r

    def t90 r, r0: R0, a: A, b: B, c: C, num: 10, err: 1e-4
      if r >= r0
        (-a + (a**2 - 4 * b * (1 - r / r0))**(0.5)) / (2 * b)
      else
        args = { r0: r0, a: a, b: b, c: c }
        Rical.inverse_for f: method(:r),   fargs: args,
                              df: method(:dr), dfargs: args,
                              x0: t90_guess(r, args), y: r,
                              method: :n, num: num, err: err
      end.to_f
    rescue RangeError
      Float::NAN
    end
    alias_method :t, :t90
    alias_method :temperature, :t90

  private
    def t90_guess r, r0:, a:, b:, c:
      ((r / r0) - 1) / (a + 100 * b)                  # valid for r < r0
    end

    def dr t90, r0:, a:, b:, c:
      r0 * (a + 2*b*t90 - 300*c*t90**2 + 4*c*t90**3)  # valid for t90 < 0
    end
  end
end
