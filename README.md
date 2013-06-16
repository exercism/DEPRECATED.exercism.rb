# Exercism

Client gem for the warmup-exercise app exercism.io.

[![Code Climate](https://codeclimate.com/github/kytrinyx/exercism.png)](https://codeclimate.com/github/kytrinyx/exercism)

## Install

    $ gem install exercism

## Usage

    $ exercism login

You will be asked for your GitHub username, and an exercism.io API key. The
API key is displayed when you log in to the exercism.io website.

    $ exercism fetch

This retrieves the README and test suite for your current assignment.

    $ exercism submit example.rb

This submits `example.rb` on your current assignment.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
