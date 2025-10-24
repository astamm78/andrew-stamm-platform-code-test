class Award

  BLUE_DISTINCTION_PLUS = "Blue Distinction Plus"
  BLUE_STAR = "Blue Star"
  BLUE_FIRST = "Blue First"
  BLUE_COMPARE = "Blue Compare"

  attr_accessor :name, :expires_in, :quality

  def initialize(name, expires_in, quality)
    self.name = name
    self.expires_in = expires_in
    self.quality = quality
  end

  def update_quality
    case name
    when BLUE_STAR
      multiplier = expired? ? 4 : 2
      decrement_quality(multiplier: multiplier)
    when BLUE_FIRST
      increment_quality(multiplier: expired? ? 2 : 1)
    when BLUE_COMPARE
      if expired?
        reset_quality
      else
        multiplier = if expires_in <= 5
          3
        elsif expires_in <= 10
          2
        else
          1
        end
        
        increment_quality(multiplier: multiplier)
      end
    else
      multiplier = expired? ? 2 : 1
      decrement_quality(multiplier: multiplier) unless is_blue_distinction_plus?
    end

    decrement_expiration
  end

  private

  def expired?
    expires_in <= 0
  end

  def is_blue_distinction_plus?
    name == BLUE_DISTINCTION_PLUS
  end

  def decrement_expiration
    self.expires_in -= 1 unless is_blue_distinction_plus?
  end

  def reset_quality
    self.quality = 0
  end

  def decrement_quality(multiplier: 1)
    self.quality = [self.quality - (1 * multiplier), 0].max
  end

  def increment_quality(multiplier: 1)
    self.quality = [self.quality + (1 * multiplier), 50].min
  end

end
