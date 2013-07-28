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
end
