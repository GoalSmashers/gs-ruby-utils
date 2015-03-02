require 'tzinfo'

class Time
  @@zone = TZInfo::Timezone.get('UTC')

  alias_method :old_add, :+
  alias_method :old_subtract, :-

  def to_json(*args)
    self.iso8601.to_json
  end

  def +(value)
    value.kind_of?(MonthsNo) ?
      value.since(self) :
      old_add(value)
  end

  def -(value)
    value.kind_of?(MonthsNo) ?
      value.ago(self) :
      old_subtract(value)
  end
end
