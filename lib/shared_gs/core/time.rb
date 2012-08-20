class Time
  def to_json(*args)
    self.iso8601.to_json
  end

  def noon
    Time.local(self.year, self.month, self.day)
  end

  def beginning_of_month
    Time.local(self.year, self.month)
  end

  def end_of_month
    Time.local(self.year, self.month) - 1.second
  end
end
