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
  
  def test_adds_correct_ruby_file
    get_test('.rb')
    assert test_suite.filename == 'fake_submission_test.rb'
  end

  def test_adds_correct_js_file
    get_test('.js')
    assert test_suite.filename == 'fake_submission.spec.js'
  end

  def test_adds_correct_elixir_file
    get_test('.exs')
    assert test_suite.filename == 'fake_submission_test.exs'
  end

  def test_adds_correct_clojure_file
    get_test('.clj')
    assert test_suite.filename == 'fake_submission_test.clj'
  end

  def test_adds_correct_python_file
    get_test('.py')
    assert test_suite.filename == 'fake_submission_test.py'
  end

  def test_adds_correct_clojure_file
    get_test('.go')
    assert test_suite.filename == 'fake_submission_test.go'
  end

  def test_adds_correct_path
    get_test('.rb')
    assert test_suite.path.end_with? 'test/fixtures/testsuites/fake_submission_test.rb'
  end

  def test_stores_suite_results
    capture_io do
      get_test('.rb')
      test_suite.run
      assert test_suite.test_result.last == 0
    end
  end

  def run_passing_suite filetype
    capture_io do
      get_test filetype
      test_suite.run
      assert test_suite.passes?
    end
  end

  def test_runs_passing_suites
    ['.rb', '.py', '.js', '.hs'].each do |filetype|
      run_passing_suite filetype
    end
  end

  def run_failing_suite filetype
    capture_io do
      get_failing_test filetype
      test_suite.run
      refute test_suite.passes?
    end
  end

  def test_runs_failing_suites
    ['.rb', '.py', '.js', '.clj', '.hs', '.exs'].each do |filetype|
      run_failing_suite filetype
    end
  end

end
