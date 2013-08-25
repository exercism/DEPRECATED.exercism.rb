require 'minitest/autorun'

begin
  require_relative 'fake_submission'
rescue LoadError => e
  eval("\"#{DATA.read}\n\"").split("\n.\n").each_with_index do |s,i|
    if i > 0
      puts "\t--- press a key to continue ---"
      gets
    end
    puts "\n\n", s, "\n\n\n"
  end
  exit!
end


class FakeSubmissionTest < Minitest::Unit::TestCase

  def test_this_will_pass
    @fake_submission = FakeSubmission.new
    assert @fake_submission.this_is_true
  end
  
end
