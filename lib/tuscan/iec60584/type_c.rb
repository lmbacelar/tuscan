module Tuscan
  module Iec60584
    module TypeC
      T90_RANGE = 0.0..2320.0
      EMF_RANGE = nil

      extend self

      def emfr_unbound t90
        Polynomial.new(
          -3.109077870000e-04,  1.338547130000e-02,  1.226236040000e-05, -1.050537530000e-08,
           3.613274640000e-12, -4.990804550000e-16,  6.434651840000e-22
        ).solve_for t90
      end
    end
  end
end
