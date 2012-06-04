class Date
  def to_json(*args)
    self.to_datetime.to_s
  end
end
