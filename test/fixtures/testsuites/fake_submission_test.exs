Code.load_file("fake_submission.exs")
ExUnit.start

defmodule FakeSubmissionTest do
  use ExUnit.Case, async: true
  doctest FakeSubmission

  test "this passes" do
    assert FakeSubmission.this_is_true == true
  end
  
end