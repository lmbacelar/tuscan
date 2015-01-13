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

## Usage

```ruby
Tuscan.t90(:iec60751, r: 110, r0: 100, a:..., b:..., c:...)
Tuscan.res(:iec60751, t: 10, r0: 100, a:..., b:..., c:...)

Tuscan.t90(:its90, r: 110, 
                   subrange:..., 
                   rtpw:..., a:..., b:..., c:..., d:..., w660:..., 
                   c1:..., c2:..., c3: ..., c4:..., c5:...)

Tuscan.t90(:iec60584, emf: 10.3e-6, type: :k)
Tuscan.emf(:iec60584, t: 10, type: :k)
```

Method `t90` aliased to `t`, `temperature`

Method `res` aliased to `r`, `resistance`

Method `emf` aliased to `v`, `voltage`


## Contributing

1. Fork it ( https://github.com/[my-github-username]/tuscan/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request ) ````
