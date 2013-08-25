require './test/test_helper'
require 'exercism/testrunner'


class TestSuiteTest < Minitest::Test

   def before
     unless self.respond_to? :capture_io
 
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
  
  def test_testrunner_captures_stdout
    capture_io do
      stdout, _, _  = Exercism::TestRunner.run_command "echo 'hello world'"
      assert stdout == "hello world\n"
    end
  end

  def test_testrunner_captures_stderr
    capture_io do
      _, stderr, _ = Exercism::TestRunner.run_command "echo error >&2"
      assert stderr == "error\n"
    end
  end

  def test_testrunner_captures_exit_code
    capture_io do
      _, _, exit = Exercism::TestRunner.run_command "echo 'hello world'"
      assert exit == 0

      _, _, exit = Exercism::TestRunner.run_command "grep"
      assert exit != 0
    end
  end
end
