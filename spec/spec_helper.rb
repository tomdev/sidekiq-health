$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'sidekiq/health'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    # disable the `should` syntax
    c.syntax = :expect
  end
end
