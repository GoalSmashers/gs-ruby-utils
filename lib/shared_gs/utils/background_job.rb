module GS
  module Utils
    class BackgroundJob
      def self.schedule(name, *args)
        object = Object.const_get("#{name.to_s}Job".camelize)

        if Application.env?(:staging, :production)
          # We call run instead to catch errors
          Navvy::Job.enqueue(object, :run, *args)
        elsif Application.env?(:development)
          Thread.new do
            sleep 3
            object.perform(*args)
          end
        else
          object.perform(*args)
        end
      end
    end
  end
end
