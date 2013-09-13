class Exercism
  class Submission

    def self.test?(file)
      new(file).test?
    end

    attr_reader :file
    def initialize(file)
      @file = file
    end

    def path
      File.expand_path(file)
    end

    def test?
      test_identifiers.any? do |_, suffix|
        file.end_with?(suffix)
      end
    end

    def test_identifiers
      {
        :ruby => '_test.rb',
        :js => '.spec.js',
        :elixir => '_test.exs',
        :clojure => '_test.clj',
        :python => '_test.py',
        :go => '_test.go',
        :haskell => '_test.hs',
      }
    end

  end
end
