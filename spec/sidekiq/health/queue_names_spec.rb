require 'spec_helper'

describe Sidekiq::Health::QueueNames do
  let(:configuration_file_path) { 'spec/fixtures/config/sidekiq.yml' }

  subject { described_class.new(configuration_file_path).get }

  context 'when configuration file exists' do
    context 'with default and prioritized queue' do
      it 'parses the configuration file' do
        expect(subject).to eq ['default', 'myqueue']
      end
    end
  end

  context 'when configuration file does not exist' do
    let(:configuration_file_path) { 'non-existing-file.yml' }

    it { expect { subject }.to raise_error Errno::ENOENT }
  end
end
