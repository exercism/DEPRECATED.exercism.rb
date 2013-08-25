class Exercism
  class TestSuite

    require 'open3'

    attr_reader :path, :filename, :filetype, :test_result
    def initialize(file)
      @filename = test_file file
      @path = "#{directory_path file}#{filename}" 
      @filetype = language file
    end

    def run command = test_config[filetype][:command]
      begin
        puts "Running test suite #{filename}..."
        puts
        @test_result = Open3.capture3 "#{command} #{path}"
        show_results
      rescue Errno::ENOENT
        show_install_help
      end
    end

    def passes?
      _, _, exit = (@test_result ||= run)
      exit == 0
    end

    def show_results
      stdout, stderr, result = test_result
      puts stdout
      puts stderr
      show_fail_message if result != 0
    end

    def show_fail_message
      puts
      puts "The test suite failed."
      puts "Check for syntax errors and tricky testcases and try again."
    end

    def show_install_help
      puts "Oops! Exercism can't run your tests."
      puts test_config[filetype][:help]
      puts "Visit http://exercism.io/setup/#{filetype.to_s} for setup help."
    end

  private
    
    def language_identifiers
      {
        '.rb'  => :ruby,
        '.js'  => :js,
        '.exs' => :elixir,
        '.hs'  => :haskell,
        '.clj' => :clojure,
        '.py'  => :python,
        '.go'  => :go,
      }
    end

    def test_config
      {
        :ruby    => { :suffix  => '_test.rb',
                      :command => 'ruby',
                      :help    => 'Ruby is missing or misconfigured.', },
        
        :js      => { :suffix  => '.spec.js',
                      :command => 'jasmine-node',
                      :help    => 'Node.js or jasmine are missing or misconfigured.', },

        :elixir  => { :suffix  => '_test.exs',
                      :command => 'elixir',
                      :help    => 'Elixir or Erlang are missing or misconfigured.', },

        :haskell => { :suffix  => '_test.hs',
                      :command => 'runhaskell',
                      :help    => 'Haskell is missing or misconfigured.', },

        :clojure => { :suffix  => '_test.clj',
                      :command => 'lein exec',
                      :help    => 'Clojure, leiningen, or lein-exec are missing or misconfigured.', },

        :python  => { :suffix  => '_test.py',
                      :command => 'python',
                      :help    => 'Python is missing or misconfigured.', },
      }
    end

    def file_extension file
      File.extname(file)
    end

    def language file
      language_identifiers[file_extension file]
    end

    def test_suffix file
      lang = language file
      raise "Invalid file. This doesn't seem to be an assignment." if lang.nil?
      test_config[lang][:suffix]
    end

    def file_name file
      File.basename(file, '.*')
    end
    
    def test_file file
      "#{file_name file}#{test_suffix file}"
    end

    def directory_path file
      file_basename = File.basename file
      File.expand_path(file).gsub(file_basename, "")
    end
    
  end
end
