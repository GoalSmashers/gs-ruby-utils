class Time
  def to_json(*args)
    self.iso8601.to_json
  end
end
