require 'yaml/store'

class Exercism
  class Config

    def self.alternate_path
      File.join(Env.home, '.config')
    end

    def self.read(path)
      config = new(path)
      config.exists? ? config : new(alternate_path)
    end

    def self.write(path, data)
      config = new(path)
      config.github_username = data['github_username']
      config.key = data['key']
      config.project_dir = data['project_dir']
      config.save
    end

    attr_reader :path
    attr_writer :github_username, :key, :project_dir

    def initialize(path)
      @path = path
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
      save_to_file
      self
    end

    def delete
      FileUtils.rm(file) if exists?
    end

    def exists?
      File.exists?(file)
    end

    def file
      @file ||= File.join(path, filename)
    end

    private

    def save_to_file
      data = {
        'github_username' => github_username,
        'key' => key,
        'project_dir' => project_dir
      }

      store.transaction do
        data.each_pair do |k,v|
          store[k] = v
        end
      end
    end

    def store
      @store ||= YAML::Store.new(file)
    end

    def filename
      default? ? ".exercism" : "exercism"
    end

    def default?
      path !~ /\.config/
    end

    def from_yaml
       @data ||= store.load(File.read(file))
       unless @data
         raise StandardError.new "Cannot read #{file}"
       end
      @data
    end

  end
end
