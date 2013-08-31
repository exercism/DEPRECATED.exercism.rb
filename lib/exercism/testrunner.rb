class Exercism
  class TestRunner

    require 'open3'

    def self.run_command command
      if open3_available?
        Open3.capture3 command
      else
        unless command_exists? command
          throw_file_not_found
        end
        out, err = get_output command
        exit = get_exit_code command
        [out, err, exit]
      end
    end

    private

    def self.command_exists? command
      `which  #{command.split.first}`
    end

    def self.get_exit_code command
      `#{command}`
      $?.to_i
    end

    def self.get_output command
      _, out, err = Open3.popen3 command
      return out.read, err.read
    end

    def self.throw_file_not_found
      raise Errno::ENOENT
    end

    def self.open3_available?
      Open3.respond_to? :capture3
    end
  end
end
