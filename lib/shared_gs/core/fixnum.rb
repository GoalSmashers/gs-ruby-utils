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
    MonthsNo.new(self)
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
    Time.zone.now - (kind_of?(MonthsNo) ? self.value : self)
  end

  def since
    Time.zone.now + (kind_of?(MonthsNo) ? self.value : self)
  end

  def from_now
    since
  end
end

class MonthsNo
  attr_reader :months_no, :value

  def initialize(months_no)
    @value = 30 * 24 * 3600 * months_no
    @months_no = months_no
  end

  def ago(from = Time.zone.now)
    months_difference(from, -1)
  end

  def since(from = Time.zone.now)
    months_difference(from, 1)
  end

  private

  def months_difference(from, direction)
    to_year = from.year + ((from.month + direction * months_no - 1) / 12.0).floor
    to_leap_year = to_year % 4 == 0 && to_year % 100 != 0

    to_month = from.month + direction * (months_no % 12)
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
