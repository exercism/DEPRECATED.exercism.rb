class Exercism
  class Config
    FILE = 'exercism'

    def self.alternate_path
      File.join(Env.home, '.config')
    end

    def self.read(path)
      config = new(path)
      config = new(alternate_path) unless config.exists?
      config
    end

    def self.write(path, data)
      config = new(path)
      config.github_username = data['github_username']
      config.key = data['key']
      config.project_dir = data['project_dir']
      config.save
    end

    attr_reader :file, :path
    attr_writer :github_username, :key, :project_dir

    def initialize(path)
      @path = path
      set_file      
    end

    def github_username
      @github_username ||= from_yaml['github_username']
    end

    def key
      @key ||= from_yaml['key']
    end

    def project_dir
      @project_dir ||= from_yaml['project_dir']
    end

    def save
      FileUtils.mkdir_p(project_dir)
      FileUtils.mkdir_p(path)

      File.open file, 'w' do |f|
        data = {
          'github_username' => github_username,
          'key' => key,
          'project_dir' => project_dir
        }
        f.write data.to_yaml
      end
      self
    end

    def delete
      FileUtils.rm(file) if exists?
    end

    def exists?
      File.exists?(@file)
    end

    private
    
    def set_file
      filename = ('.' if is_default?) + FILE
      @file = File.join(@path, filename)
    end

    def is_default?
      @path != /\.config/
    end

    def from_yaml
      unless @data
         @data = YAML.load(File.read(file))
         unless @data
           raise StandardError.new "Cannot read #{file}"
         end
      end
      @data
    end

  end
end
