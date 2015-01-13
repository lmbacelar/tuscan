# **TUSCAn**
### **T**emperat**U**re **S**ensor **CA**lculator

Makes available functions to:

* Get _temperature_ from _resistance_ for IEC 60751 and ITS-90 thermoresistances
* Get _resistance_ from _temperature_ for IEC 60751 thermoresistances
* Get _temperature_ from electro-motive force (_emf_) for IEC 60584 thermocouples
* Get _emf_ from _temperature_ for IEC 60584 thermocouples


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
Tuscan.t(:iec60751, r: 110, r0: 100, a:..., b:..., c:...)
Tuscan.r(:iec60751, t: 10, r0: 100, a:..., b:..., c:...)

Tuscan.t(:its90, r: 110, 
                 subrange:..., 
                 rtpw:..., a:..., b:..., c:..., d:..., w660:..., 
                 c1:..., c2:..., c3: ..., c4:..., c5:...)

Tuscan.t(:iec60584, emf: 10.3e-6, type: :k)
Tuscan.emf(:iec60584, t: 10, type: :k)
```

Method `t` aliased to `t90`, `temperature`

Method `r` aliased to `res`, `resistance`

## Contributing

1. Fork it ( https://github.com/[my-github-username]/tuscan/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request ) ````
