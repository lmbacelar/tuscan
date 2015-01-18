require 'byebug'

module Tuscan
  module Iec60584
    extend self

    def t90 emf, type:, a: 0.0, b: 0.0, c: 0.0, d: 0.0, err: 1e-3, num: 10
      emfc = emf - emfdev(t90r(emf, type, err, num), a, b, c, d)
      t90r emfc, type, err, num
    end
    alias_method :t, :t90
    alias_method :temperature, :t90

    def emfr t90, type
      raise RangeError, 't90 is outside the valid range' if out_of_range? t90, type
      emfr_unbound t90, type
    end

    def t90r emf, type, err, num
      guess = t90r_guess emf, type
      Rical.inverse_for f: method(:emfr_unbound), fargs: type, x0: guess - 0.5, x1: guess + 0.5,
                        y: emf, method: :secant, num: num, err: err * 1e-3
    end

    def emfdev t90, a, b, c, d
      Polynomial.new(a, b, c, d).solve_for t90
    end

  private
    def t90r_guess emf, type
      tc(type).t90r_guess emf
    end

    def emfr_unbound t90, type
      tc(type).emfr_unbound t90
    end

    def out_of_range? t90, type
      !tc(type)::T90_RANGE.include? t90
    end

    def tc type
      self.const_get "Type#{type.upcase}"
    end
  end
end
