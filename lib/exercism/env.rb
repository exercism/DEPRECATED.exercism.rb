class Exercism
  class Env
    def self.home
      if ENV["OS"] == 'Windows_NT' then
        ENV["HOMEDRIVE"]+ENV["HOMEPATH"]
      else
        return File.expand_path('~') if RUBY_VERSION == '1.8.7'
        Dir.home(Etc.getlogin)
      end
    end
  end
end
