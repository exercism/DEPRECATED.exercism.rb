require 'thor'

class Exercism
  class CLI < Thor
    require 'exercism'

    desc "version", "Output current version of gem"
    def version
      puts Exercism::VERSION
    end

    map "-v" => "version", "--version" => "version"

    desc "fetch", "Fetch current assignment from exercism.io"
    method_option :host, aliases: '-h', default: 'http://exercism.io', desc: 'the url of the exercism application'
    def fetch
      api = Exercism::Api.new(options[:host], Exercism.user, Exercism.project_dir)
      assignments = api.fetch
      if assignments.empty?
        puts "No assignments fetched."
      else
        assignments.each do |assignment|
          puts "Fetched #{File.join(assignment.assignment_dir)}"
        end
      end
    end

    desc "peek", "Fetch upcoming assignment from exercism.io"
    method_option :host, aliases: '-h', default: 'http://exercism.io', desc: 'the url of the exercism application'
    def peek
      api = Exercism::Api.new(options[:host], Exercism.user, Exercism.project_dir)
      assignments = api.peek
      if assignments.empty?
        puts "No assignments fetched."
      else
        assignments.each do |assignment|
          puts "Fetched #{File.join(assignment.assignment_dir)}"
        end
      end
    end

    desc "submit FILE", "Submit code to exercism.io on your current assignment"
    method_option :host, aliases: '-h', default: 'http://exercism.io', desc: 'the url of the exercism application'
    def submit(file)
      path = File.join(FileUtils.pwd, file)
      begin
        Exercism::Api.new(options[:host], Exercism.user).submit(file)
        puts "Your assignment has been submitted."
        puts "Check the website for feedback in a bit."
      rescue Exception => e
        puts "There was an issue with your submission."
        puts e.message
      end
    end

    desc "login", "Save exercism.io api credentials"
    def login
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
      Exercism.config.delete
    end

    desc "whoami", "Get the github username that you are logged in as"
    def whoami
      puts Exercism.user.github_username
    rescue Errno::ENOENT
      puts "You are not logged in."
    end

  end
end
