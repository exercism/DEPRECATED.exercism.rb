require 'minitest/autorun'

require File.expand_path('../failing_submission.rb', __FILE__)

class FailingSubmissionTest < Minitest::Test

  def test_this_will_pass
    @failing_submission = FailingSubmission.new
    assert @failing_submission.this_is_false
  end
  
end
