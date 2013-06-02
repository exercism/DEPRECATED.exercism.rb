require 'etc'
require 'json'
require 'yaml'
require 'fileutils'
require 'faraday'
require 'exercism/version'
require 'exercism/config'
require 'exercism/user'
require 'exercism/assignment'
require 'exercism/api'

class Exercism

  def self.url
    if ENV['EXERCISM_ENV'] == 'test'
      'http://localhost:4567'
    else
      'http://exercism.herokuapp.com'
    end
  end

  def self.home
    Dir.home(Etc.getlogin)
  end

  def self.login(github_username, key)
    data = {'github_username' => github_username, 'key' => key}
    Config.write(home, data)
    User.new(github_username, key)
  end

  def self.config
    Config.read(home)
  end

  def self.user
    c = config
    User.new(c.github_username, c.key)
  end

end
