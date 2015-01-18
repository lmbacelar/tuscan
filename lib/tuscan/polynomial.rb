module Tuscan
  class Polynomial
    def initialize *coeffs
      @coeffs = coeffs
    end

    def solve_for x
      @coeffs.each_with_index.map{ |c,i| c*x**i }.reduce(:+)
    end
  end
end
