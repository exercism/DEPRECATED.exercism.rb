class Exercism
  class Env
    def self.home
      if ENV["OS"] == 'Windows_NT' then
        ENV["HOMEDRIVE"]+ENV["HOMEPATH"]
      else
        Dir.home(Etc.getlogin)
      end
    end
  end
end
