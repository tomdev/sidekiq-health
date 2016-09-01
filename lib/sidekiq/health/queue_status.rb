require 'sidekiq/api'

module Sidekiq
  module Health
    MAXIMUM_HEALTHY_QUEUE_SIZE = 50
    MAXIMUM_HEALTHY_DEAD_SET_LAST_HOUR_SIZE = 5

    class QueueStatus
      class Status
        def initialize(queue_name, dead_set)
          @queue_name = queue_name
          @dead_set = dead_set
        end

        attr_reader :queue_name

        def total_number_of_jobs
          sidekiq_queue.size
        end

        def total_number_of_failed_jobs
          dead_set.size
        end

        def total_number_of_failed_jobs_since(timestamp)
          dead_set.select { |item| item['failed_at'] > timestamp.to_r }.size
        end

        def number_of_scheduled_jobs_per_class_name
          @number_of_scheduled_jobs_per_class_name ||= sidekiq_queue.inject({}) do |job_pool, scheduled_job|
            wrapped_class = scheduled_job['wrapped']
            job_pool[wrapped_class] = job_pool.fetch(wrapped_class, 0) + 1
            job_pool
          end
            .sort_by { |job_name, count| count }
            .to_h
        end

        def health_as_human_readable_string
          health = []

          if total_number_of_jobs > Sidekiq::Health::MAXIMUM_HEALTHY_QUEUE_SIZE
            more_than_allowed = total_number_of_jobs - Sidekiq::Health::MAXIMUM_HEALTHY_QUEUE_SIZE
            health << "There are a total of #{total_number_of_jobs} scheduled jobs, "\
              "which is #{more_than_allowed} more than healthy."
          end

          dead_in_last_hour = total_number_of_failed_jobs_since(1.hour.ago)
          if dead_in_last_hour > Sidekiq::Health::MAXIMUM_HEALTHY_DEAD_SET_LAST_HOUR_SIZE
            more_than_allowed = dead_in_last_hour - Sidekiq::Health::MAXIMUM_HEALTHY_DEAD_SET_LAST_HOUR_SIZE
            health << "There are a total of #{dead_in_last_hour} failed jobs, "\
              "which is #{more_than_allowed} more than healthy."
          end

          if health.empty?
            health << "Everything looks good."
          end

          health.join(" ")
        end

        private

        attr_reader :dead_set

        def sidekiq_queue
          @sidekiq_queue ||= Sidekiq::Queue.new queue_name
        end
      end

      def print
        output = ""

        queue_names.each do |name|
          output << "\n" unless output == ""
          output << QueueHealthFormatter.new(name, queue_size(name)).to_s
        end

        output
      end

      def statuses
        Sidekiq::DeadSet.new

        queue_names.map do |name|
          Status.new \
            name,
            dead_set_for(queue_name: name)
        end
      end

      private

      def queue_size(name)
        Sidekiq::Queue.new(name).size
      end

      def queue_names
        Sidekiq::Health::QueueNames.new.get
      end

      def dead_set_for(queue_name:)
        all_dead_jobs.fetch(queue_name, [])
      end

      def all_dead_jobs
        @all_dead_jobs ||= Sidekiq::DeadSet.new.inject({}) do |all_jobs, item|
          all_jobs[item.queue] = all_jobs.fetch(item.queue, []) + [item]
          all_jobs
        end
      end
    end

    class QueueHealthFormatter
      attr_reader :name, :size

      def initialize(name, size)
        @name = name
        @size = size
      end

      def to_s
        if healthy?
          "OK. #{queue_information}"
        else
          "WARNING: TOO MANY JOBS ENQUEUED. #{queue_information}"
        end
      end

      def healthy?
        size < Sidekiq::Health::MAXIMUM_HEALTHY_QUEUE_SIZE
      end

      private

      def queue_information
        "Queue: \"#{name}\" Size: #{size}"
      end
    end
  end
end
