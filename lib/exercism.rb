require 'rubygems' if RUBY_VERSION <= "1.8.7"
require 'etc'
require 'json'
require 'yaml'
require 'fileutils'

old_warn, $-w = $-w, nil
begin
  require 'faraday'
ensure
  $-w = old_warn
end

require 'exercism/version'
require 'exercism/env'
require 'exercism/config'
require 'exercism/user'
require 'exercism/assignment'
require 'exercism/submission'
require 'exercism/testsuite'
require 'exercism/api'

class Exercism

  def self.home
    @home ||= Env.home
  end

  def self.login(github_username, key, dir)
    data = {
      'github_username' => github_username,
      'key' => key,
      'project_dir' => dir
    }
    Config.write home, data
  end

  def self.user
    c = config
    User.new(c.github_username, c.key)
  end

  def self.project_dir
    config.project_dir
  end

  def self.alternate_config_path
    Config.alternate_path
  end

  def self.config
    Config.read(home)
  end
end
