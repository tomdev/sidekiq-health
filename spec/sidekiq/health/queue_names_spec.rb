require 'spec_helper'

describe Sidekiq::Health::QueueNames do
  context 'with configuration file available' do
    context 'with default and prioritized queue' do
      it 'parses the configuration file'
    end
  end

  context 'without configuration file available' do
    it 'raises'
  end
end
