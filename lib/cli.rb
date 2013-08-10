require 'timeout'
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

      # # 1. get path to test file on users system
      # use project_dir method from Exercism gem
      path_to_bob_test = Exercism.project_dir+'/ruby/bob/bob_test.rb'


      # 2. intercept stderr to check whether tests passed, failed, or other
        # first problem we ran into was missing file for test
        # doesn't throw an error, but rather asks user for input
        # this waits for user input, so we tried to timeout 
        # can't figure out how to kill the process

        # here are our attempts so far
        process_thread = Thread.new do
          `ruby #{path_to_bob_test}` 
        end

        timeout_thread = Thread.new do
          sleep 4   # the timeout
          if process_thread.alive?
            $stderr.puts "Timeout"
            process_thread.kill
          end
        end

        # process_thread.join
        # timeout_thread.kill
        puts "killed process thread"


        # we want to rescue the errors, but can't proceed
        # until figuring out how to kill the process 

      # begin
      #   status = Timeout::timeout(4) {
      #     output = `ruby #{path_to_bob_test}`
      #   }
      #   puts "putting status"
      #   p status
      #   status
      # rescue Error
      #   puts "hey your shit blew up"
      # end

      # system("rm -rf temp")



      # 3. If all tests are passing, then allow user to submit
      #  Note: Didn't get to this step, because hung up on 
      # the issue above. Unable to kill process in test file.
      



      # # # # #
      # NOTE : DON'T ACTUALLY SUBMIT
      return

      begin
        # NOTE : DON"T ACTUALLY SUBMIT
        # response = Exercism::Api.new(options[:host], Exercism.user).submit(submission.file)
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

  end
end
