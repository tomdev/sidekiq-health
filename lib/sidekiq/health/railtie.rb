require 'sidekiq/health'

module Sidekiq
  module Health
    require 'rails'

    class Railtie < ::Rails::Railtie
      rake_tasks { load "sidekiq/tasks/sidekiq_health.rake" }
    end
  end
end
