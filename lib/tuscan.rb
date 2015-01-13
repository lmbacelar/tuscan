require 'tuscan/version'
require 'tuscan/its90'
require 'tuscan/iec60751'
require 'tuscan/iec60584'

module Tuscan
  extend self

private
  def method_missing method, *args, &block 
    subject, *remaining_args = args
    const_get(subject.to_s.capitalize).send method, *remaining_args, &block
  end
end
