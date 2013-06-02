class Exercism
  class Assignment

    attr_reader :track, :slug, :readme, :testfile, :tests

    def initialize(attributes)
      @track = attributes['track']
      @slug = attributes['slug']
      @readme = attributes['readme']
      @testfile = attributes['testfile']
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
      File.join(assignment_dir, testfile)
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

