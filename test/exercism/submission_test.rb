require './test/test_helper'
require 'exercism/submission'

class SubmissionTest < Minitest::Test
  def test_knows_ruby
    assert Exercism::Submission.test?('queens_test.rb')
  end
 
  def test_knows_elixir
    assert Exercism::Submission.test?('queens_test.exs')
  end

  def test_knows_javascript
    assert Exercism::Submission.test?('queens.spec.js')
  end
end
