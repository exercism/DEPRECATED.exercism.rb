class Exercism
  class TestRunner

    require 'open3'

    def self.run_command command
      if Open3.respond_to? :capture3
        Open3.capture3 command
      else
        out, err = capture_io do
          if Kernel.system command
            exit = 0
          else
            exit = 1
          end
        end
        [out, err, exit]
      end
    end

    private
    
    def self.capture_io &block 
      stdout = $stdout
      $stdout = new_out = StringIO.new

      stderr = $stderr
      $stderr = new_err = StringIO.new
      begin
        yield
      ensure
        $stdout = stdout
        $stderr = stderr
      end
      return new_out.string, new_err.string
    end
  end
end
