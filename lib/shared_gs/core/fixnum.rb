class Fixnum
  def second
    self
  end

  def seconds
    second
  end

  def minute
    60 * self
  end

  def minutes
    minute
  end

  def hour
    3600 * self
  end

  def hours
    hour
  end

  def day
    24 * 3600 * self
  end

  def days
    day
  end

  def month
    30 * 24 * 3600 * self
  end

  def months
    month
  end

  def year
    (365.25 * 24 * 3600 * self).to_i
  end

  def years
    year
  end

  def ago
    Time.now - self
  end

  def since
    Time.now + self
  end

  def from_now
    since
  end
end
