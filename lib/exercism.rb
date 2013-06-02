require 'yaml'
require 'etc'
require 'fileutils'
require 'exercism/version'
require 'exercism/config'
require 'exercism/user'
require 'exercism/assignment'

class Exercism

  def self.home
    Dir.home(Etc.getlogin)
  end

  def self.login(github_username, key)
    data = {'github_username' => github_username, 'key' => key}
    Config.write(home, data)
    User.new(github_username, key)
  end

  def self.user
    config = Config.read(home)
    User.new(config.github_username, config.key)
  end

end
