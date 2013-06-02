require 'thor'

class Exercism
  class CLI < Thor

    desc "fetch", "Fetch current assignment from exercism.io"
    def fetch
      require 'exercism'

      Exercism::Api.fetch_for(Exercism.user)
    end

    desc "submit FILE", "Submit code to exercism.io on your current assignment"
    def submit(file)
      require 'exercism'

      Exercism::Api.submit(file, {for: Exercism.user})
    end

    desc "login", "Save exercism.io api credentials"
    def login
      require 'exercism'

      username = ask("Your GitHub username:")
      key = ask("Your exercism.io API key:")
      Exercism.login(username, key)

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

  end
end
