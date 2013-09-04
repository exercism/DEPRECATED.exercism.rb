require 'faraday/adapter/net_http'

class Exercism
  class Api

    attr_reader :url, :user, :project_dir
    def initialize(url, user, project_dir = nil)
      @url = url
      @user = user
      @project_dir = project_dir
    end

    def conn
      Faraday.new(:url => url) do |c|
        c.use Faraday::Adapter::NetHttp
        c.headers['User-Agent'] = user_agent
      end
    end

    def demo
      get_and_save('assignments/demo')
    end

    def fetch
      get_and_save('user/assignments/current')
    end

    def peek
      get_and_save('user/assignments/next')
    end

    def submit(filename)
      path = File.join(filename)
      contents = File.read path

      json_request(:post, 'user/assignments', {
        :key  => user.key,
        :code => contents,
        :path => path
      })
    end

    def unsubmit
      json_request(:delete, 'user/assignments', {
        :key => user.key
      })
    end

    def save_stash(action, filename)
      path = File.join(filename)
      contents = File.read path
      response = conn.post do |req|
        req.url endpoint(action)
        req.headers['Accept'] = 'application/json'
        req.headers['Content-Type'] = 'application/json'
        req.body = {:code => contents, :key => user.key, :filename => path}.to_json
      end
      response
    end

    def apply_stash(action, filename)
      get_stash(action, filename)
    end

    def list_stash(action)
      response = conn.get do |req|
        req.url endpoint(action)
        req.params['key'] = user.key
      end
      JSON.parse(response.body)
    end

    private

    def get_stash(action, filename)
      response = conn.get do |req|
        req.url endpoint(action)
        req.params['key'] = user.key
        req.params['filename'] = filename
      end
      Stash.new(JSON.parse(response.body))
    end

    def get_and_save(action)
      response = conn.get do |req|
        req.url endpoint(action)
        req.params['key'] = user.key
      end
      save response.body
    end

    def json_request(verb, path, body)
      response = conn.send(verb) do |request|
        request.url endpoint(path)
        request.headers['Accept'] = 'application/json'
        request.headers['Content-Type'] = 'application/json'
        request.body = body.to_json
      end

      response
    end

    def user_agent
      "github.com/kytrinyx/exercism CLI v#{Exercism::VERSION}"
    end

    def endpoint(action = nil)
      "/api/v1/#{action}".chomp('/')
    end

    def save(body)
      Assignment.save(JSON.parse(body), project_dir)
    end
  end
end

