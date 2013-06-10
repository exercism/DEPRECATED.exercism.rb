class Exercism
  class Assignment

    def self.save(data)
      data['assignments'].each do |attributes|
        Assignment.new(attributes).save
      end
    end

    attr_reader :track, :slug, :readme, :test_file, :tests

    def initialize(attributes)
      @track = attributes['track']
      @slug = attributes['slug']
      @readme = attributes['readme']
      @test_file = attributes['test_file']
      @tests = attributes['tests']
    end

    def save
      FileUtils.mkdir_p assignment_dir
      File.open readme_path, 'w' do |f|
        f.write readme
      end
      File.write tests_path, tests
    end

    private

    def readme_path
      File.join(assignment_dir, 'README.md')
    end

    def tests_path
      File.join(assignment_dir, test_file)
    end

    def assignment_dir
      File.join(project_dir, track, slug)
    end

    def project_dir
      dir = FileUtils.pwd
      if File.basename(dir) == track
        dir.gsub(/#{track}\z/, '')
      else
        dir
      end
    end
  end
end

