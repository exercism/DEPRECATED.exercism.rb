class Exercism
  class Env
    def self.home
      if windows_nt?
        ENV["HOMEDRIVE"] + ENV["HOMEPATH"]
      elsif ruby18?
        File.expand_path('~')
      else
        Dir.home(Etc.getlogin)
      end
    end

    def self.windows_nt?
      ENV["OS"] == 'Windows_NT'
    end

    def self.ruby18?
      RUBY_VERSION == '1.8.7'
    end
  end
end
