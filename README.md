# Consenter

`Enumerable#each_consented` is an opinionated but idiomatic way to filter elements of an `Enumerable` by user consent.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'consenter'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install consenter

## Usage

`Enumerable#each_consented` works exactly like `Enumerable#each`, but before yielding each element of the collection, it prompts the user (via the `IO#console`, ie. `/dev/tty`) for confirmation, using the prompt provided as an argument.

A simple example: `puts 0.upto(9).each_consented('Pick %d?').sum` will print out the sum of all numbers between `0` and `9` which the user has picked.

The following example shows the interaction:

* each element is passed to `Kernel#format` to generate the customizable prompt
* answering `y` will cause the current element to be yielded
* answering `Y` will cause the current element and all remaining ones to be yielded
* answering `n` will cause the current element to be skipped
* answering `N` will cause the current element and all remaining ones to be skipped
* answering `q` will cause the iteration to be aborted
* answering `?` will print out a help message
* answering anything else will also print out the help message

```ruby
$ ruby -r consenter -e 'puts 0.upto(9).each_consented("Pick %d?").sum'
Pick 0? [y,n,Y,N,q,?] ?
y - yes to this
n - no to this
Y - yes to this and all remaining
N - no to this and all remaining
q - quit
? - help
Pick 0? [y,n,Y,N,q,?] y
Pick 1? [y,n,Y,N,q,?] n
Pick 2? [y,n,Y,N,q,?] n
Pick 3? [y,n,Y,N,q,?] n
Pick 4? [y,n,Y,N,q,?] y
Pick 5? [y,n,Y,N,q,?] y
Pick 6? [y,n,Y,N,q,?] N
9
$ _
```

## Automation

To use the consenter logic in Ruby scripts that are run non-interactively, e.g. via `cron`, where a human cannot be prompted for answers, you can provide options to pick all or none of the objects in the `Enumerable` without invoking the prompt:

```ruby
$ ruby -r consenter -e 'puts 0.upto(9).each_consented("Pick %d?", all: true).sum'
45
$ _
```

Alternatively:

```ruby
$ ruby -r consenter -e 'puts 0.upto(9).each_consented("Pick %d?", none: true).sum'
0
$ _
```

Obviously, instead of providing hard-coded `true` values for the `all:` or `none:` options, you would provide a boolean check, e.g. one that checks an environment variable:

```ruby
$ ruby -r consenter -e 'puts 0.upto(9).each_consented("Pick %d?", all: ENV.fetch("CI", false)).sum'
```

This version would prompt like demoed above when the script is run interactively:

```ruby
$ ruby -r consenter -e 'puts 0.upto(9).each_consented("Pick %d?", all: ENV.fetch("CI", false)).sum'
Pick 0? [y,n,Y,N,q,?] y
Pick 1? [y,n,Y,N,q,?] y
Pick 2? [y,n,Y,N,q,?] y
Pick 3? [y,n,Y,N,q,?] n
Pick 4? [y,n,Y,N,q,?] N
3
$ _
```

... but would default to selecting all objects in the `Enumerable` when it is running in a CI environment like SemaphoreCI or Jenkins:

```ruby
$ CI=true ruby -r consenter -e 'puts 0.upto(9).each_consented("Pick %d?", all: ENV.fetch("CI", false)).sum'
45
$ _
```

Another possible scenario is that you prompt the user if the script is running in interactive mode, but decide to select `all:` or `none:` of the enumerable elements if the script is run non-interactively, e.g. as part of a `cron` job.

So, to select `all:` of the elements when in non-interactive mode you can use:

```ruby
$ </dev/null ruby -r consenter -e 'puts 0.upto(9).each_consented("Pick %d?", all: !STDIN.tty?).sum'
45
$ _
```

... and to select `none:` of the elements you would use this instead:

```ruby
$ </dev/null ruby -r consenter -e 'puts 0.upto(9).each_consented("Pick %d?", none: !STDIN.tty?).sum'
0
$ _
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pvdb/consenter.
