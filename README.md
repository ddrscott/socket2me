# Socket2me

Execute Javascript in the browser from the server using WebSockets.

This is a proof of concept. There are no attempts to secure this feature or
even make it practical in a multi-user environment. That's right, any browser
that is viewing the site is going to get the same javascript executed on it.
This gem should really only ever be used in development.

The original use for this was to send all logs to browser as it was appended.

```ruby
def pipe_to_browser(src)
  File.open(src,"r") do |f|
    f.seek(0,IO::SEEK_END)
    while true do
      IO.select([f])    # wait for change
      line = f.gets
      Socket2me.exec_js "$('#logs').append(#{line.to_json})"
    end
  end
end
Thread.new{pipe_to_browser('log/development.log')}
```

Please don't run this in production. Ever.

## Installation

Add this line to your application's Gemfile:

```ruby
group :development, :test do
  gem 'socket2me'
end
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install socket2me

## Usage

A full rack example is in `example/counter.ru`. That app simply creates
an HTML page and provides a helper js function to display some output. The
example then outputs the server time a counter every second in a background
thread.

To run `example/counter.rb`:

1. checkout the project: `git clone https://github.com/ddrscott/socket2me`
2. go into the the socket2me directory: `cd socket2me`
3. install requirements: `./bin/setup`
4. start a rack server with the example: `rackup example/counter.ru`

### Rack
```ruby
# config.ru
use SocketToMe::Middleware::AddScriptTag
```

### Rails
```ruby
# config/environments/development.rb
config.middleware.use SocketToMe::Middleware::AddScriptTag
```

### Execute Javascript
```ruby
# elsewhere.rb
SocketToMe.exec_js "alert('hello world!')"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

Spot check everything works by running `rackup example/counter.ru`. The browser
should continually append a timestamp and counter below the header.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ddrscott/socket2me.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

