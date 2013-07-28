require 'rubygems' if RUBY_VERSION == '1.8.7'
require 'thor'

class Exercism
  class CLI < Thor

    desc "version", "Output current version of gem"
    def version
      require 'exercism'

      puts Exercism::VERSION
    end

    map "-v" => "version", "--version" => "version"

    desc "demo", "Fetch first assignment for each language from exercism.io"
    method_option :host, :aliases => '-h', :default => 'http://exercism.io', :desc => 'the url of the exercism application'
    def demo
      require 'exercism'

      guest = Object.new
      def guest.key
        "demo"
      end

      exercism = Exercism::Api.new(options[:host], guest, '.')
      assignments = exercism.demo
      report(assignments)
    end

    desc "fetch", "Fetch current assignment from exercism.io"
    method_option :host, :aliases => '-h', :default => 'http://exercism.io', :desc => 'the url of the exercism application'
    def fetch
      require 'exercism'

      assignments = api.fetch
      report(assignments)
    end

    desc "peek", "Fetch upcoming assignment from exercism.io"
    method_option :host, :aliases => '-h', :default => 'http://exercism.io', :desc => 'the url of the exercism application'
    def peek
      require 'exercism'

      assignments = api.peek
      report(assignments)
    end

    desc "submit FILE", "Submit code to exercism.io on your current assignment"
    method_option :host, :aliases => '-h', :default => 'http://exercism.io', :desc => 'the url of the exercism application'
    def submit(file)
      require 'exercism'

      submission = Submission.new(file)

      if submission.test?
        say "It looks like this is a test, you probably don't want to do that."
        if no?("Do you want to submit it anyway? [y/n]")
          return
        end
      end

      begin
        response = Exercism::Api.new(options[:host], Exercism.user).submit(submission.file)
        say "Your assignment has been submitted."

        body = JSON.parse(response.body)
        url = "#{options[:host]}/#{Exercism.user.github_username}/#{body['language']}/#{body['exercise']}"
        say "For feedback on your submission visit #{url}"
      rescue Exception => e
        puts "There was an issue with your submission."
        puts e.message
      end
    end

    desc "login", "Save exercism.io api credentials"
    def login
      require 'exercism'

      username = ask("Your GitHub username:")
      key = ask("Your exercism.io API key:")
      default_dir = FileUtils.pwd
      say "What is your exercism exercises project path?"
      say "Press Enter to select the default (#{default_dir}):\n"
      dir = ask ">"
      if dir.empty?
        dir = default_dir
      end
      project_dir = File.expand_path(dir)

      say "Where do you want your configuration stored? (type a number)"
      say "1. #{File.join(Exercism.home, '.exercism')}"
      say "2. #{File.join(Exercism.home, '.config', 'exercism')}"

      if ask(">").to_i == 2
        Exercism.login username, key, project_dir, File.join(Exercism.home, '.config')
      else
        Exercism.login username, key, project_dir, Exercism.home
      end

      say("Your credentials have been written to #{Exercism.config.file}")
    end

    desc "logout", "Clear exercism.io api credentials"
    def logout
      require 'exercism'

      Exercism.config.delete
    end

    desc "whoami", "Get the github username that you are logged in as"
    def whoami
      require 'exercism'

      puts Exercism.user.github_username
    rescue Errno::ENOENT
      puts "You are not logged in."
    end

    private

    def api(host = options[:host])
      Exercism::Api.new(host, Exercism.user, Exercism.project_dir)
    end

    def report(assignments)
      if assignments.empty?
        puts "No assignments fetched."
      else
        assignments.each do |assignment|
          puts "Fetched #{File.join(assignment.assignment_dir)}"
        end
      end
    end

  end
end
