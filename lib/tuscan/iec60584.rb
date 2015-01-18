module Tuscan
  module Iec60584
    extend self

    def emfr t90, type, range_check = true
      self.const_get("Type#{type.upcase}").emfr t90, range_check
    end

    def t90r emf, type, err: 1e-3, num: 100
      guess = t90r_guess emf, type
      Rical.inverse_for f: method(:emfr), fargs: type, x0: guess - 0.5, x1: guess + 0.5,
                        y: emf, method: :secant, num: num, err: err * 1e-3
    end

  private
    def t90r_guess emf, type
      self.const_get("Type#{type.upcase}").t90r_guess emf
    end
  end
end
