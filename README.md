# Exercism

Client gem for the warmup-exercise app exercism.io.

[![Code Climate](https://codeclimate.com/github/kytrinyx/exercism.png)](https://codeclimate.com/github/kytrinyx/exercism)
[![Build Status](https://travis-ci.org/kytrinyx/exercism.png?branch=master)](https://travis-ci.org/kytrinyx/exercism)
[![Gem Version](https://badge.fury.io/rb/exercism.png)](https://rubygems.org/gems/exercism)

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

    $ exercism stash save example.rb

This saves 'example.rb' to exercism.io as an unfinished "stash" file that can be retrieved later. Helpful for use on multiple computers: stash the file you're working on at computer 1, then retrieve it with the loot command on computer 2.

    $ exercism stash apply example.rb

This retrieves the most recent stash file, if one exists, and saves it to the current directory.

    $ export EXERCISM_ENV=development

Reveals stack traces on errors.

By default, Exercism will create a config file in the base of your home directory, i.e. `~/.exercism`. This file can be moved to `~/.config/exercism` if desired.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
