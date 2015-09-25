require 'spec_helper'

describe Sidekiq::Health::QueueStatus do
  before do
    allow_any_instance_of(Sidekiq::Queue).to receive(:size).and_return queue_size
    allow_any_instance_of(described_class).to receive(:queue_names).and_return queue_names
  end

  describe '#status' do
    subject { described_class.new.print }

    context 'with queue size smaller than threshold' do
      let(:queue_size) { 1 }

      context 'with one queue' do
        let(:queue_names) { %w{ some_queue } }

        it 'returns OK' do
          expect(subject).to eq "OK. Queue: \"#{queue_names[0]}\" Size: 1"
        end
      end

      context 'with multiple queues' do
        let(:queue_names) { %w{ Q1 Q2 } }

        it 'return OK' do
          expect(subject).to eq "OK. Queue: \"#{queue_names[0]}\" Size: 1\n" \
            "OK. Queue: \"#{queue_names[1]}\" Size: 1"
        end
      end
    end

    context 'with queue size larger than threshold' do
      let(:queue_size) { 50 }

      context 'with one queue' do
        let(:queue_names) { %w{ some_queue } }

        it 'returns WARNING' do
          expect(subject).to eq \
            "WARNING: TOO MANY JOBS ENQUEUED. Queue: \"#{queue_names[0]}\" Size: 50"
        end
      end
    end
  end
end


  # context 'with a healty queue' do
  #   before do
      # allow_any_instance_of(Sidekiq::Queue).to receive(:size).and_return(1)
  #   end

  #   it { is_expected.to eq 'OK. QUEUE SIZE: 1'}
  # end

  # context 'with an unhealthy queue' do
  #   before do
  #     allow_any_instance_of(Sidekiq::Queue).to receive(:size).and_return(50)
  #   end

  #   it { is_expected.to eq 'WARNING: TOO MANY JOBS ENQUEUED. QUEUE SIZE: 50'}
  # end
