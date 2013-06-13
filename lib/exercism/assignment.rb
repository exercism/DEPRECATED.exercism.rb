class Exercism
  class Assignment

    def self.save(data, path)
      assignments = []
      data['assignments'].each do |attributes|
        assignments << Assignment.new(attributes.merge('project_dir' => path)).save
      end
      assignments
    end

    attr_reader :track, :slug, :readme, :test_file, :tests, :project_dir

    def initialize(attributes)
      @track = attributes['track']
      @slug = attributes['slug']
      @readme = attributes['readme']
      @test_file = attributes['test_file']
      @tests = attributes['tests']
      @project_dir = attributes['project_dir']
    end

    def save
      FileUtils.mkdir_p assignment_dir
      File.open readme_path, 'w' do |f|
        f.write readme
      end
      File.write tests_path, tests
      self
    end

    def assignment_dir
      @assignment_dir ||= File.join(project_dir, track, slug)
    end

    private

    def readme_path
      File.join(assignment_dir, 'README.md')
    end

    def tests_path
      File.join(assignment_dir, test_file)
    end
  end
end

