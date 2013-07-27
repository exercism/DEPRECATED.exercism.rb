class Exercism
  class Submission

    def self.test?(file)
      submission = new(file)
      submission.test?
    end

    attr_reader :file
   
    def initialize(file)
      @file = file
    end
 
    def test?
      test_identifiers.any? {|_, test_suffix| file.end_with?(test_suffix)}
    end

    def test_identifiers
      { :ruby => '_test.rb', :js => '.spec.js', :elixir => '_test.exs' }
    end

  end
end
