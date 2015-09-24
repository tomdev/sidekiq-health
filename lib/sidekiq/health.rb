module Sidekiq
  module Health
    LIBRARY_PATH = File.join(File.dirname(__FILE__), 'health')
    GEM_PATH = File.dirname(__FILE__)

    %w{
      queue_status
      version
    }.each {|lib| require File.join(LIBRARY_PATH, lib) }
  end
end

