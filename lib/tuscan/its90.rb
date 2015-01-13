module Tuscan
  module Its90
    include Math
    extend self

    A = [ -2.13534729, 3.1832472,  -1.80143597,
           0.71727204, 0.50344027, -0.61899395,
          -0.05332322, 0.28021362,  0.10715224,
          -0.29302865, 0.04459872,  0.11868632,
          -0.05248134 ]

    B = [  0.183324722,  0.240975303,  0.209108771,
           0.190439972,  0.142648498,  0.077993465,
           0.012475611, -0.032267127, -0.075291522,
          -0.05647067,   0.076201285,  0.123893204,
          -0.029201193, -0.091173542,  0.001317696,
           0.026025526 ]

    C = [  2.78157254,  1.64650916, -0.1371439,
          -0.00649767, -0.00234444,  0.00511868,
           0.00187982, -0.00204472, -0.00046122,
           0.00045724 ]

    D = [ 439.932854, 472.41802, 37.684494,
            7.472018,   2.920828, 0.005184,
           -0.963864,  -0.188732, 0.191203,
            0.049025 ]

    def t90 r, rtpw:, **args
      w = r / rtpw
      Its90.t90r w - wdev(Its90.t90r(w), args)
    end

    # SUBRANGES = 1..11

    # T90_RANGE  = -259.4467..961.88
    # WR_RANGE   =  0.00119007..4.28642053

    #
    # VALID TEMPERATURE RANGES
    #
    # def range
    #   WDEV_EQUATIONS[subrange - 1][:valid]
    # end


    #
    # ITS-90 REFERENCE FUNCTIONS
    #
    def self.wr t90
      # return nil unless T90_RANGE.include? t90
      if t90< 0.01
        exp(A.each_with_index.collect{ |a, i| a*( (log((t90+273.15)/273.16) + 1.5)/1.5 )**i }.reduce(:+))
      else
        C.each_with_index.collect{ |c, i| c*((t90-481)/481)**i }.reduce(:+)
      end
    end

    def self.t90r wr
      # return nil unless WR_RANGE.include? wr
      if wr < 1.0
        B.each_with_index.collect{ |b, i| b*(((wr)**(1.0/6)-0.65)/0.35)**i }.reduce(:+) * 273.16 - 273.15
      else
        D.each_with_index.collect{ |d, i| d*((wr-2.64)/1.64)**i }.reduce(:+)
      end
    end

    #
    # ITS-90 DEVIATION FUNCTIONS
    #
    WDEV_EQUATIONS = [ { valid: (-259.4467..0.01),   k: %w(c1 c2 c3 c4 c5), n: 2 }, 
                       { valid: (-248.5939..0.01),   k: %w(c1 c2 c3      ), n: 0 },
                       { valid: (-218.7916..0.01),   k: %w(c1            ), n: 1 },
                       { valid: (-189.3442..0.01),   k: %w(              )       },
                       { valid: (0.0..961.78),       k: %w(a  b  c  d    )       },
                       { valid: (0.0..660.323),      k: %w(a  b  c       )       },
                       { valid: (0.0..419.527),      k: %w(a  b          )       },
                       { valid: (0.0..231.928),      k: %w(a  b          )       },
                       { valid: (0.0..156.5985),     k: %w(a             )       },
                       { valid: (0.0..29.7646),      k: %w(a             )       },
                       { valid: (-38.8344..29.7646), k: %w(a  b          )       } ]

    def wdev t90, subrange: ,
                  a: 0.0, b: 0.0, c: 0.0, d: 0.0, w660: 0.0,
                  c1: 0.0, c2: 0.0, c3: 0.0, c4: 0.0, c5: 0.0
      equation = WDEV_EQUATIONS[subrange - 1]
      # return nil unless equation[:valid].include? t90
      wr_t90 = Its90.wr t90
      case subrange
      when 1..4
        wdev  = a * (wr_t90 - 1)
        subrange == 4 ?
          wdev += b * (wr_t90 - 1) * log(wr_t90) :
          wdev += b * (wr_t90 - 1)**2
        wdev += equation[:k].each_with_index.
                  collect{ |k, i| eval("#{k}") * log(wr_t90)**(i + equation[:n]) }.reduce(:+) || 0
      when 5..11
        wdev   = d * (wr_t90 - w660)**2 if equation[:k].delete('d')
        wdev ||= 0
        wdev  += equation[:k].each_with_index.
                    collect{ |k, i| eval("#{k}") * (wr_t90 - 1)**(i+1) }.reduce(:+)
      end
    end
  end
end
