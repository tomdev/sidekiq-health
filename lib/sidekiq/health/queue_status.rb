require 'sidekiq/api'

module Sidekiq
  module Health
    class QueueStatus
      def print
        output = ""

        queue_names.each do |name|
          output << "\n" unless output == ""
          output << QueueHealthFormatter.new(name, size_for_queue(name)).to_s
        end

        output
      end

      private

      def size_for_queue(name)
        Sidekiq::Queue.new(name).size
      end

      def queue_names
        # TODO: Read queue names from configuration
        %w{ mailers default slow }
      end
    end

    class QueueHealthFormatter
      QUEUE_SIZE_WARNING_THRESHOLD = 50

      attr_reader :name, :size

      def initialize(name, size)
        @name = name
        @size = size
      end

      def to_s
        if size < QUEUE_SIZE_WARNING_THRESHOLD
          "OK. #{queue_information}"
        else
          "WARNING: TOO MANY JOBS ENQUEUED. #{queue_information}"
        end
      end

      private

      def queue_information
        "Queue: \"#{name}\" Size: #{size}"
      end
    end
  end
end
