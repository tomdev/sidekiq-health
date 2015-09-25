require 'yaml'

module Sidekiq
  module Health
    class QueueNames
      attr_reader :configuration

      def initialize(configuration_file_path)
        @configuration = YAML.load_file(configuration_file_path)
      end

      def get
        configuration[:queues].map { |q| q.is_a?(Array) ? q[0] : q }
      end
    end
  end
end
