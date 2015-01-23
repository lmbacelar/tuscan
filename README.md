# **TUSCAn**
### **T**emperat**U**re **S**ensor **CA**lculator

Makes available functions for:

* ITS-90 compatible temperature sensors (Standard Platinum Resistance Thermometers), allowing:
  * Retrieval of reference resistance ratio _W<sub>R</sub>_ from _t<sub>90R</sub>_ reference temperature
  * Retrieval of reference temperature _t<sub>90R</sub>_ from _W<sub>R</sub>_ reference resistance ratio
  * Given sensor coefficient's: _sub-range_, _R<sub>tpw</sub>_, _a_, _b_, _c_, _d_, _W<sub>660</sub>_, _c<sub>1</sub>_, _c<sub>2</sub>_, _c<sub>3</sub>_, _c<sub>4</sub>_, _c<sub>5</sub>_
    * Retrieval of  _t<sub>90</sub>_ temperature from sensor's resistance _res_ 
    * Retrieval of  _res_ resistance from sensor's _t<sub>90</sub>_ temperature. 
* IEC 60751 compatible temperature sensors (Platinum Resistance Thermometers), allowing:
  * Retrieval of reference resistance _res<sub>R</sub>_ from _t<sub>90R</sub>_ reference temperature
  * Retrieval of reference temperature _t<sub>90R</sub>_ from _res<sub>R</sub>_ reference resistance
  * Given sensor coefficient's: _R<sub>0</sub>_, _A_, _B_, _C_
    * Retrieval of sensor's resistance _res_ from _t<sub>90</sub>_ temperature
    * Retrieval of temperature _t<sub>90</sub>_ from sensor's resistance _res_
* IEC 60584 compatible temperature sensors (Thermocouples), allowing, for a given _type_:
  * Retrieval of reference voltage _emf<sub>R</sub>_ from _t<sub>90R</sub>_ reference temperature
  * Retrieval of reference temperature _t<sub>90R</sub>_ from reference voltage _emf<sub>R</sub>_
  * Given sensor coefficient's: _a_, _b_, _c_, _d_
    * Retrieval of sensor's voltage _emf_ from _t<sub>90</sub>_ temperature
    * Retrieval of temperature _t<sub>90</sub>_ from sensor's voltage _emf_


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
# Reference functions (ºC vs Ohm/Ohm)
Tuscan.wr(:its90, 23.456)
Tuscan.t90r(:its90, 1.15)

# Corrected for specific sensor (ºC vs Ohm)
Tuscan.t90(:its90, 25.319871, rtpw: 25.319871, subrange: 7, a: -1.2134e-04, b: -9.9190e-06)
Tuscan.res(:its90, 0.01,      rtpw: 25.319871, subrange: 7, a: -1.2134e-04, b: -9.9190e-06)
```

**IEC 60751**
```ruby
# Reference functions (ºC vs Ohm)
Tuscan.t90r(:iec60751, 110)
Tuscan.resr(:iec60751, 10)

# Corrected for specific sensor
Tuscan.t90(:iec60751, 110, r0: 99.876, a:3.9083e-03, b:-5.7750e-07, c:-4.1830e-12)
Tuscan.res(:iec60751, 10,  r0: 99.876, a:3.9083e-03, b:-5.7750e-07, c:-4.1830e-12)
```

**IEC 60584**
```ruby
# Reference functions (ºC vs mV)
Tuscan.t90r(:iec60584, 1.234,  type: :k)
Tuscan.emfr(:iec60584, 10.123, type: :k)

# Corrected for specific sensor
Tuscan.t90(:iec60584, 3.6105,  type: :k, a: 0, b: -1.39363e-05, c: 3.75578e-08, d: -2.17624e-11)
Tuscan.emf(:iec60584, 419.527, type: :k, a: 0, b: -1.39363e-05, c: 3.75578e-08, d: -2.17624e-11)
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
