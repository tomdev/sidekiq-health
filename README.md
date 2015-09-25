# Sidekiq::Health

Sidekiq::Health prints the size of your Sidekiq Queues with either an `OK` or `WARNING` tag, the queue name and size. The current threshold is set to 50 meaning that when there are more than 49 jobs enqueued Sidekiq::Health will mark the queue as "too busy".

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

Sidekiq::Health is intended to be used within a Rails project. When added to your project's Gemfile a rake task will be added:

    $ rake sidekiq::queue::status

Which, depending on your `config/sidekiq.yml` and state of Sidekiq will result in:

```
WARNING: TOO MANY JOBS ENQUEUED. Queue: "mailers" Size: 75
OK. Queue: "default" Size: 0
```
Match the "WARNING" with your favorite monitoring tool and escalate accordingly.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tomdev/sidekiq-health.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Credits

I was inspired by Alex Stoll from HE:labs http://helabs.com/blog/2015/02/19/a-simple-way-to-monitor-sidekiq-queue-on-rails-and-sinatra/
