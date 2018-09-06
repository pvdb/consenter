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

```
$ ruby -r consenter -e "puts 0.upto(9).each_consented('Pick %d?').sum"
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


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pvdb/consenter.
