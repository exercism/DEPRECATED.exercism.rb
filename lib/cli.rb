require 'rubygems' if RUBY_VERSION == '1.8.7'
require 'thor'
require 'exercism/cli/stash.rb'

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

    desc "open", "Opens exercism.io in your default browser"
    def open
      require 'launchy'

      Launchy.open("http://exercism.io")
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
    method_option :ask, :aliases => '-a', :default => false, :type => :boolean, :desc => 'ask before submitting assignment'
    def submit(file)
      require 'exercism'
      require 'cli/monitored_request'

      submission = Submission.new(file)

      if submission.test?
        say "It looks like this is a test, you probably don't want to do that."
        if no?("Do you want to submit it anyway? [y/n]")
          return
        end
      end

      if options[:ask]
        if no?("Are you sure you want to submit this assignment? [y/n]")
          return
        end
      end

      MonitoredRequest.new(api).request :submit, submission.path do |request, body|
        say "Your assignment has been submitted."
        url = "#{options[:host]}/#{Exercism.user.github_username}/#{body['language']}/#{body['exercise']}"
        say "For feedback on your submission visit #{url}"
      end
    end

    desc "unsubmit", "Delete the last submission"
    method_option :host, :aliases => '-h', :default => 'http://exercism.io', :desc => 'the url of the exercism application'
    def unsubmit
      require 'exercism'
      require 'cli/monitored_request'

      MonitoredRequest.new(api).request :unsubmit do |request, body|
        if response.status == 204
          say "The last submission was successfully deleted."
        end
      end
    end

    desc "login", "Save exercism.io api credentials"
    def login
      require 'exercism'

      Exercism.login username, key, project_dir

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

    desc "current", "Get the current exercise that you are on"
    method_option :host, :aliases => '-h', :default => 'http://exercism.io', :desc => 'the url of the exercism application'
    def current
      require 'exercism'

      result = Exercism::Api.new(options[:host], Exercism.user).current
      body = JSON.parse(result.body)
      puts "Current Assignments"
      body['assignments'].each do |assignment|
        track = assignment['track']
        puts "Language: " + track.ljust(17) + "Exercise: " + assignment['slug']
      end
    end

    desc "stash [SUBCOMMAND]", "Stash or apply code that is in-progress"
    subcommand "stash", Stash

    private

    def username
      ask("Your GitHub username:")
    end

    def key
      ask("Your exercism.io API key:")
    end


    def project_dir
      default_dir = FileUtils.pwd
      say "What is your exercism exercises project path?"
      say "Press Enter to select the default (#{default_dir}):\n"
      dir = ask ">", :default => default_dir
      File.expand_path(dir)
    end

    def api(host = options[:host])
      Exercism::Api.new(host, Exercism.user, Exercism.project_dir)
    end

    def report(assignments)
      if assignments.empty?
        say "No assignments fetched."
      else
        assignments.each do |assignment|
          say "\nFetched #{assignment.exercise}"
          say File.join(assignment.exercise, 'README.md')
          say File.join(assignment.exercise, assignment.test_file)
        end
      end
    end

    def spacing(track)
      len = 17 - track.length
      space = ''
      len.times {space += ' '}
      space
    end
  end  
end
