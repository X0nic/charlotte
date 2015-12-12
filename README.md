# Charlotte

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/charlotte`. To experiment with that code, run `bin/console` for an interactive prompt.

A web crawler that will show you a map of all static assets

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'charlotte'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install charlotte

## Usage

    # Fetch and display all links and assets for a site
    $ charlotte fetch duckduckgo.com

    # Fetch and display all links and assets for a site, but only decend two levels
    $ charlotte fetch duckduckgo.com -l 2

    # Fetch site, and display links between all pages
    $ charlotte visualize_pages duckduckgo.com

    # Fetch site, and display links between pages and assets
    $ charlotte visualize_assets duckduckgo.com

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment. Run `bundle exec charlotte` to use the gem in this directory, ignoring other installed copies of this gem.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/charlotte.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

