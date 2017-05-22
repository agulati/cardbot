class Card < ApplicationRecord

  attr_accessor :value, :suit, :display

  def initialize(options = {})
    @suit     = options[:suit]
    @value    = options[:value]
    @display  = options[:display]
  end

  def to_s
    "#{display} of #{suit.to_s.titleize}"
  end
end
