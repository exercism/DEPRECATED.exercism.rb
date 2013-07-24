require 'rubygems' if RUBY_VERSION <= "1.8.7"
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

      path = File.join(FileUtils.pwd, file)
      begin
        response = Exercism::Api.new(options[:host], Exercism.user).submit(file)
        puts "Your assignment has been submitted."
        url = submission_url(response.body, options[:host])
        puts "For feedback on your submission visit #{url}"
      rescue Exception => e
        puts "There was an issue with your submission."
        puts e.message
      end if confirms_submission?
    end

    desc "login", "Save exercism.io api credentials"
    def login
      require 'exercism'

      username = ask("Your GitHub username:")
      key = ask("Your exercism.io API key:")
      default_path = FileUtils.pwd
      path = ask("What is your exercism exercises project path? (#{default_path})")
      if path.empty?
        path = default_path
      end
      path = File.expand_path(path)
      Exercism.login(username, key, path)

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

    def submission_url(response_body, host)
      body = JSON.parse(response_body)
      "#{host}/user/#{body['language']}/#{body['exercise']}" 
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

    def confirms_submission?
      confirm = ask("Are you SURE you want to submit? (anything other than 'y' or 'yes' will cancel)")
      confirm == 'y' || confirm == 'yes'
    end

  end
end
