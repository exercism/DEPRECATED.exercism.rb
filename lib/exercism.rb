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
require 'exercism/config'
require 'exercism/user'
require 'exercism/assignment'
require 'exercism/api'

class Exercism

  def self.home
    if ENV["OS"] == 'Windows_NT' then
      ENV["HOMEDRIVE"]+ENV["HOMEPATH"]
    else
      return File.expand_path('~') if RUBY_VERSION <= "1.8.7"
      Dir.home(Etc.getlogin)
    end
  end

  def self.login(github_username, key, dir)
    data = {
      'github_username' => github_username,
      'key' => key,
      'project_dir' => dir
    }
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

  def self.project_dir
    config.project_dir
  end

end
