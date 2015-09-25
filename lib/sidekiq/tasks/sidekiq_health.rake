namespace :sidekiq do
  namespace :queue do
    desc "Output current queue size of all Sidekiq queues"
    task :status => :environment do
      puts Sidekiq::Health::QueueStatus.new.print
    end
  end
end
