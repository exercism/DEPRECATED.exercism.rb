require 'minitest/autorun'

require File.expand_path('../fake_submission.rb', __FILE__)

class FakeSubmissionTest < Minitest::Unit::TestCase

  def test_this_will_pass
    @fake_submission = FakeSubmission.new
    assert @fake_submission.this_is_true
  end
  
end
