module GS
  module Jobs
    class AbstractJob
      def self.run(*args)
        perform(*args)
      rescue Exception => e
        Bugsnag.notify(e)
      end

      def self.perform
        raise NotImplementedError.new
      end
    end
  end
end
