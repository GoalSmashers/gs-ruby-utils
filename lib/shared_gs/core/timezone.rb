require 'tzinfo'

class TZInfo::Timezone
  def local(*args)
    utc_to_local(Time.utc(*args))
  end

  def at(*args)
    if args.length == 1 && args[0].is_a?(Time)
      utc_to_local(args[0])
    elsif args.length == 1 && args[0].is_a?(Numeric)
      utc_to_local(Time.strptime(args[0].to_s, '%s'))
    else
      local(*args)
    end
  end
end

class Time
  def midnight
    self.class.zone.local(year, month, day)
  end

  def noon
    self.class.zone.local(year, month, day, 12)
  end

  def beginning_of_week
    midnight - (sunday? ? 6 : self.wday - 1).days
  end

  def end_of_week
    midnight + (sunday? ? 1 : 8 - wday).days - 1.second
  end

  def next_week
    end_of_week + 1.second
  end

  def beginning_of_month
    self.class.zone.local(year, month)
  end

  def end_of_month
    self.month < 12 ?
      self.class.zone.local(year, month + 1) - 1.second :
      self.class.zone.local(year + 1, 1) - 1.second
  end

  def beginning_of_year
    self.class.zone.local(year)
  end

  def end_of_year
    self.class.zone.local(year + 1) - 1.second
  end

  def self.zone=(new_zone)
    @@zone = TZInfo::Timezone.get(new_zone)
  end

  def self.zone
    @@zone
  end
end
