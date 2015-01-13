# **TUSCAn**
### **T**emperat**U**re **S**ensor **CA**lculator

Makes available functions for:

* ITS-90 compatible temperature sensors (Standard Platinum Resistance Thermometers), allowing:
  * Retrieval of reference resistance ratio _Wr_ from _t90r_ reference temperature
  * Retrieval of reference temperature _t90r_ from _Wr_ reference resistance ratio
  * Given sensor coefficient's: _sub-range_, _Rtpw_, _a_, _b_, _c_, _d_, _W660_, _c1_, _c2_, _c3_, _c4_, _c5_
    * Retrieval of resistance ratio deviation  _Wdev_ from _t90_, for each of the 11 sub-ranges of ITS-90
    * Retrieval of  _t90_ temperature from sensor's resistance _r_. 
* IEC 60751 compatible temperature sensors (Platinum Resistance Thermometers), allowing:
  * Given sensor coefficient's: _R0_, _A_, _B_, _C_
    * Retrieval of sensor's resistance _r_ from _t90_ temperature
    * Retrieval of temperature _t90_ from sensor's resistance _r_
* IEC 60584 compatible temperature sensors (Thermocouples), allowing, for a given _type_:
  * Retrieval of reference voltage _emfr_ from _t90r_ reference temperature
  * Retrieval of reference temperature _t90r_ from reference voltage _emfr_


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tuscan'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tuscan

## Usage examples

**ITS-90**
```ruby
Tuscan.wr(:its90, 23.456)  # t90 in ºC
Tuscan.t90r(:its90, 1.15)  # wr in Ohm / Ohm

Tuscan.wdev(:its90, 23.456, subrange: 4, a: -1.2579994e-04, b: 1.0678395e-05)

Tuscan.t90(:its90, r: 28.3433, rtpw: 25.319871, subrange: 7, a: -1.2134e-04, b: -9.9190e-06)
```

**IEC 60751**
```ruby
Tuscan.t90(:iec60751, r: 110)  # t90 in ºC, r in Ohm
Tuscan.res(:iec60751, t: 10, r0: 99.876, a:3.9083e-03, b:-5.7750e-07, c:-4.1830e-12)
```

**IEC 60584**
```ruby
Tuscan.t90r(:iec60584, emf: 1.234, type: :k)  # emf im mV
Tuscan.emfir(:iec60584, t: 10.123, type: :k)  # t90 in ºC
```


### Notes
* `t90` aliased to `t`, `temperature`
* `res` aliased to `r`, `resistance`
* `emf` aliased to `v`, `voltage`


## Contributing

1. Fork it ( https://github.com/[my-github-username]/tuscan/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
