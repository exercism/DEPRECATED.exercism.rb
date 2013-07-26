class Exercism
  class AssignmentSubmission
    def initialize(view, submission = Exercism::Api)
      @view = view
      @submission = submission
    end

    def submit!
      @file = @view.assignment_to_upload
      choose_another_file! while selected_file_are_tests?
      return if quit?
 
      if confirm?
        path = File.join(FileUtils.pwd, @file)

        begin
          @submission.new(options[:host], Exercism.user).submit(@file)
          @view.submission_succeeded
        rescue Exception => e
          @view.submission_failed(e.message)
        end
      end
    end

  private
    def options
      @view.options
    end

    def choose_another_file!
      @view.retry_another_file
      @file = @answer = @view.assignment_to_upload
    end

    def quit?
      @answer == 'q' || @answer == ''
    end
 
    def selected_file_are_tests?
      test_identifiers.any? {|language, test_suffix| @file.end_with?(test_suffix)}
    end

    def test_identifiers
      { :ruby => '_test.rb', :js => '.spec.js', :elixir => '_test.exs' }
    end

    def confirm?
      @view.confirm_submission
      @answer = @view.confirmation_answer
      @answer == 'y' || @answer == 'yes'
    end
  end
end
