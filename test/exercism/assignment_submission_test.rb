require './test/test_helper'
require 'exercism/assignment_submission'

class MockView
  attr_reader :files

  def initialize
    @attempts = 1
  end

  def retries_made
    @attempts
  end

  def assignment_to_upload
    files.shift        
  end

  def retry_another_file
    @attempts += 1
  end

  def confirm_submission
  end

  def confirmation_answer
    true 
  end
end

class AssignmentSubmission < Minitest::Test

  def test_detects_test_files
    [
      ['sample_test.rb', 'sample.rb'], 
      ['sample.spec.js', '.spec.js', 'sample.js'],
      ['sample_test.exs', 'word_tet.exs']
    ].each do |files|
      expected_number_of_tried_files = files.count

      ui = MockView.new
      api = Minitest::Mock.new
   
      ui.stub(:files, files) do
        Exercism::AssignmentSubmission.new(ui, api).submit!
        assert_equal expected_number_of_tried_files, ui.retries_made
      end
    end
  end

end
