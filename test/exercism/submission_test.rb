require './test/test_helper'
require 'exercism/submission'

class SubmissionTest < Minitest::Test
  def test_knows_ruby_code
    refute Exercism::Submission.test?('queens.rb')
  end

  def test_identifies_ruby_tests
    assert Exercism::Submission.test?('queens_test.rb')
  end

  def test_knows_elixir_code
    refute Exercism::Submission.test?('queens.exs')
  end

  def test_identifies_elixir_tests
    assert Exercism::Submission.test?('queens_test.exs')
  end

  def test_knows_javascript_code
    refute Exercism::Submission.test?('queens.js')
  end

  def test_identifies_javascript_tests
    assert Exercism::Submission.test?('queens.spec.js')
  end

  def test_knows_clojure_code
    refute Exercism::Submission.test?('queens.clj')
  end

  def test_identifies_clojure_tests
    assert Exercism::Submission.test?('queens_test.clj')
  end

  def test_knows_python_code
    refute Exercism::Submission.test?('queens.py')
  end

  def test_identifies_python_tests
    assert Exercism::Submission.test?('queens_test.py')
  end

  def test_knows_go_code
    refute Exercism::Submission.test?('queens.go')
  end

  def test_identifies_go_tests
    assert Exercism::Submission.test?('queens_test.go')
  end
end
