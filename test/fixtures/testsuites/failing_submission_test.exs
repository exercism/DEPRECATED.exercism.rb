Code.load_file("test/fixtures/testsuites/failing_submission.exs")
ExUnit.start

defmodule FailingSubmissionTest do
  use ExUnit.Case, async: true
  doctest FailingSubmission

  test "this fails" do
    assert FailingSubmission.this_is_false == true
  end
  
end