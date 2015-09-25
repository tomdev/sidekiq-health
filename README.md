# Sidekiq::Health

Sidekiq::Health prints the size of your Sidekiq Queues with either an `OK` or `WARNING` tag for processing by monitoring scripts. The current threshold is set to 50 meaning that when there are more than 49 jobs enqueued Sidekiq::Health will mark the queue as "too busy".

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sidekiq-health'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sidekiq-health

## Requirements

Sidekiq::Health expects you to have the default Sidekiq configuration file located in `config/sidekiq.yml`.

NOTE: Only names queues are supported at this time.

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tomdev/sidekiq-health.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

