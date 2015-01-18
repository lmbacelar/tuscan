require 'tuscan/version'
require 'tuscan/polynomial'
require 'tuscan/its90'
require 'tuscan/iec60751'
require 'tuscan/iec60584'
require 'tuscan/iec60584/type_b'
require 'tuscan/iec60584/type_c'
require 'tuscan/iec60584/type_e'
require 'tuscan/iec60584/type_j'
require 'tuscan/iec60584/type_k'
require 'tuscan/iec60584/type_n'
require 'tuscan/iec60584/type_r'
require 'tuscan/iec60584/type_s'
require 'tuscan/iec60584/type_t'

module Tuscan
  extend self

private
  def method_missing method, *args, &block 
    subject, *remaining_args = args
    const_get(subject.to_s.capitalize).send method, *remaining_args, &block
  end
end
