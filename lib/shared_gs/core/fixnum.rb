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

  def week
    7 * 24 * 3600 * self
  end

  def weeks
    week
  end

  def month
    new_value = 30 * 24 * 3600 * self
    new_value.instance_variable_set('@_months_diff', self)
    new_value
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

  def ago(from = Time.zone.now)
    _months_diff ?
      months_difference(from, -1) :
      from - self
  end

  def since(from = Time.zone.now)
    _months_diff ?
      months_difference(from, 1) :
      from + self
  end

  def from_now
    since
  end

  private

  attr_reader :_months_diff

  def months_difference(from, direction)
    to_year = from.year + ((from.month + direction * _months_diff - 1) / 12.0).floor
    to_leap_year = to_year % 4 == 0 && to_year % 100 != 0

    to_month = from.month + direction * (_months_diff % 12)
    to_month += 12 if to_month < 1
    to_month -= 12 if to_month > 12

    to_day = case from.day
    when 30..31
      to_day = if [4, 6, 9, 11].include?(to_month)
        30
      elsif to_month == 2
        to_leap_year ? 29 : 28
      else
        from.day
      end
    when 29
      to_month == 2 && !to_leap_year ? 28 : from.day
    else
      from.day
    end

    Time.zone.local(to_year, to_month, to_day, from.hour, from.min, from.sec)
  end
end
