module Tuscan
  module Iec60584
    extend self

    def emfr t90, type
      raise RangeError, 't90 is outside the valid range' if out_of_range? t90, type
      emfr_unbound t90, type
    end

    def t90r emf, type, err: 1e-3, num: 100
      guess = t90r_guess emf, type
      Rical.inverse_for f: method(:emfr_unbound), fargs: type, x0: guess - 0.5, x1: guess + 0.5,
                        y: emf, method: :secant, num: num, err: err * 1e-3
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
