require './test/test_helper'
require 'exercism/testsuite'

class TestSuiteTest < Minitest::Test

  attr_reader :test_suite
  def get_test file_extension
    unless file_extension == '.hs'
      filename = "fake_submission#{file_extension}"
    else
      filename = "fakesubmission.hs"
    end
    @test_suite = Exercism::TestSuite.new("./test/fixtures/testsuites/#{filename}")
  end

  def get_failing_test file_extension
    unless file_extension == '.hs'
      filename = "failing_submission#{file_extension}"
    else
      filename = "failingsubmission.hs"
    end
    @test_suite = Exercism::TestSuite.new("./test/fixtures/testsuites/#{filename}")
  end
  
  def run_passing_suite filetype
    out, err = capture_io do
      get_test filetype
      test_suite.run
      assert test_suite.passes?
    end
  end

  def test_runs_passing_suites
    ['.rb', '.py', '.js', '.clj', '.exs'].each do |filetype|
      run_passing_suite filetype
    end
  end

  def run_failing_suite filetype
    out, err = "", ""
    out, err = capture_io do
      get_failing_test filetype
      test_suite.run
      refute test_suite.passes?
    end
    message = "The test suite failed."
    assert (out.include? message) || (err.include? message)
  end

  def test_runs_failing_and_erroring_suites
    ['.rb', '.py', '.js', '.clj', '.hs', '.exs'].each do |filetype|
      run_failing_suite filetype
    end
  end
end
