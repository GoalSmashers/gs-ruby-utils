require 'tzinfo'

class Time
  @@zone = TZInfo::Timezone.get('UTC')

  def to_json(*args)
    self.iso8601.to_json
  end
end
