require 'spec_helper'

describe Sidekiq::Health::QueueStatus do
  before do
    stub_const 'Sidekiq::Health::QueueNames', Class.new
  end

  def stub_queue_names(queue_names)
    allow_any_instance_of(Sidekiq::Health::QueueNames).to receive(:get)
      .and_return queue_names
  end

  def stub_queue_size(*args)
    queue_stubs = *args
    queue_stubs.each do |queue_stub|
      allow_any_instance_of(described_class).to receive(:queue_size)
        .with(queue_stub[0])
        .and_return(queue_stub[1])
    end
  end

  describe '#status' do
    subject { described_class.new.print }

    context 'with queue size smaller than threshold' do
      let(:queue_size) { 1 }

      context 'with one queue' do
        before do
          stub_queue_names(['default'])
          stub_queue_size(['default', 1])
        end

        it 'returns OK' do
          expect(subject).to eq "OK. Queue: \"default\" Size: 1"
        end
      end

      context 'with multiple queues' do
        before do
          stub_queue_names(['default', 'myqueue'])
          stub_queue_size(['default', 1], ['myqueue', 1])
        end

        it 'return OK' do
          expect(subject).to eq "OK. Queue: \"default\" Size: 1\n" \
            "OK. Queue: \"myqueue\" Size: 1"
        end
      end
    end

    context 'with queue size larger than threshold' do
      let(:queue_size) { 50 }

      context 'with one queue' do
        before do
          stub_queue_names(['default'])
          stub_queue_size(['default', 50])
        end

        it 'returns WARNING' do
          expect(subject).to eq \
            "WARNING: TOO MANY JOBS ENQUEUED. Queue: \"default\" Size: 50"
        end
      end

      context 'with multiple queues' do
        before do
          stub_queue_names(['default', 'myqueue'])
          stub_queue_size(['default', 50], ['myqueue', 100])
        end

        it 'returns WARNING' do
          expect(subject).to eq \
            "WARNING: TOO MANY JOBS ENQUEUED. Queue: \"default\" Size: 50\n" \
            "WARNING: TOO MANY JOBS ENQUEUED. Queue: \"myqueue\" Size: 100" \
        end
      end
    end
  end
end
