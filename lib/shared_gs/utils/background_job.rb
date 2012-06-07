class BackgroundJob
  def self.schedule(name, *args)
    object = Object.const_get("#{name.to_s}Job".camelize)

    if Application.env?([:staging, :production])
      # We call run instead to catch errors
      Navvy::Job.enqueue(object, :run, *args)
    else
      object.perform(*args)
    end
  end
end