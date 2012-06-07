class AbstractJob
  def self.run(*args)
    perform(*args)
  rescue Exception => e
    Airbrake.notify(e)
  end

  def self.perform
    raise NotImplementedError.new
  end
end