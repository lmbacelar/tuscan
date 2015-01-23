module Tuscan
  module Its90
    include Math
    extend self

    T90_RANGE = -273.16..961.78
    WR_RANGE  =    0.00..4.28642053

    def t90 r, rtpw:, **args
      w = r / rtpw
      t90r w - wdev(t90r(w), args)
    end
    alias_method :t, :t90
    alias_method :temperature, :t90

    def r t90, rtpw:, num: 100, err: 1e-6, **args
      guess = wr t90
      delta = 1e-2
      Rical.inverse_for f: method(:t90_unbound), fargs: { rtpw: rtpw, **args },
                        x0: guess - delta, x1: guess + delta,
                        y: t90, method: :secant, num: num, err: err * 1e-1
    end
    alias_method :res, :r
    alias_method :resistance, :r

    def wr t90
      raise RangeError, 't90 is outside the valid range' unless T90_RANGE.include? t90
      if t90< 0.01
        a = [ -2.13534729,  3.1832472,  -1.80143597, 0.71727204,  0.50344027, -0.61899395, -0.05332322,
               0.28021362,  0.10715224, -0.29302865, 0.04459872,  0.11868632, -0.05248134 ]
        exp(a.each_with_index.collect{ |ai, i| ai*( (log((t90+273.15)/273.16) + 1.5)/1.5 )**i }.reduce(:+))
      else
        c = [  2.78157254,  1.64650916, -0.1371439, -0.00649767, -0.00234444,  0.00511868,  0.00187982,
              -0.00204472, -0.00046122,  0.00045724 ]
        c.each_with_index.collect{ |ci, i| ci*((t90-481)/481)**i }.reduce(:+)
      end
    end

    def t90r wr
      raise RangeError, 'wr is outside the valid range' unless WR_RANGE.include? wr
      if wr < 1.0
        b = [  0.183324722,  0.240975303,  0.209108771,  0.190439972,  0.142648498,  0.077993465,
               0.012475611, -0.032267127, -0.075291522, -0.05647067,   0.076201285,  0.123893204,
              -0.029201193, -0.091173542,  0.001317696,  0.026025526 ]
        b.each_with_index.collect{ |bi, i| bi*(((wr)**(1.0/6)-0.65)/0.35)**i }.reduce(:+) * 273.16 - 273.15
      else
        d = [ 439.932854, 472.41802, 37.684494,  7.472018,  2.920828,  0.005184, -0.963864,
               -0.188732,   0.191203, 0.049025 ]
        d.each_with_index.collect{ |di, i| di*((wr-2.64)/1.64)**i }.reduce(:+)
      end
    end

    def wdev t90, subrange: ,
                  a: 0.0, b: 0.0, c: 0.0, d: 0.0, w660: 0.0,
                  c1: 0.0, c2: 0.0, c3: 0.0, c4: 0.0, c5: 0.0
      raise RangeError, 't90 is outside the valid range' if out_of_range? t90, subrange
      wdev_unbound t90, subrange: subrange, a: a, b: b, c: c, d: d, w660: w660, c1: c1, c2: c2, c3: c3, c4: c4, c5: c5
    end

  private
    def t90_unbound r, rtpw:, **args
      w = r / rtpw
      t90r w - wdev_unbound(t90r(w), args)
    end

    def wdev_unbound t90, subrange: ,
                  a: 0.0, b: 0.0, c: 0.0, d: 0.0, w660: 0.0,
                  c1: 0.0, c2: 0.0, c3: 0.0, c4: 0.0, c5: 0.0
      equation = wdev_equation subrange
      wr_t90 = wr t90
      case subrange
      when 1..4
        wdev  = a * (wr_t90 - 1)
        subrange == 4 ?
          wdev += b * (wr_t90 - 1) * log(wr_t90) :
          wdev += b * (wr_t90 - 1)**2
        wdev += equation[:k].each_with_index.
                  collect{ |k, i| call(k) * log(wr_t90)**(i + equation[:n]) }.reduce(:+) || 0
      when 5..11
        wdev   = d * (wr_t90 - w660)**2 if equation[:k].delete('d')
        wdev ||= 0
        wdev  += equation[:k].each_with_index.
                    collect{ |k, i| eval("#{k}") * (wr_t90 - 1)**(i+1) }.reduce(:+)
      end
    end

    def wdev_equation subrange
      case subrange
      when  1 then { k: %w(c1 c2 c3 c4 c5), n: 2 }
      when  2 then { k: %w(c1 c2 c3      ), n: 0 }
      when  3 then { k: %w(c1            ), n: 1 }
      when  4 then { k: %w(              )       }
      when  5 then { k: %w(a  b  c  d    )       }
      when  6 then { k: %w(a  b  c       )       }
      when  7 then { k: %w(a  b          )       }
      when  8 then { k: %w(a  b          )       }
      when  9 then { k: %w(a             )       }
      when 10 then { k: %w(a             )       }
      when 11 then { k: %w(a  b          )       }
      end
    end

    def out_of_range? t90, subrange
      case subrange
      when   1 then !(-259.4467..0.01    ).include? t90
      when   2 then !(-248.5939..0.01    ).include? t90
      when   3 then !(-218.7916..0.01    ).include? t90
      when   4 then !(-189.3442..0.01    ).include? t90
      when   5 then !(      0.0..961.78  ).include? t90
      when   6 then !(      0.0..660.323 ).include? t90
      when   7 then !(      0.0..419.527 ).include? t90
      when   8 then !(      0.0..231.928 ).include? t90
      when   9 then !(      0.0..156.5985).include? t90
      when  10 then !(      0.0..29.7646 ).include? t90
      when  11 then !( -38.8344..29.7646 ).include? t90
      end
    end
  end
end
