class Exercism
  class Api

    attr_reader :url, :user, :project_dir
    def initialize(url, user, project_dir = nil)
      @url = url
      @user = user
      @project_dir = project_dir
    end

    def conn
     conn = Faraday.new(:url => url) do |c|
        c.use Faraday::Adapter::NetHttp
        c.headers['User-Agent'] = user_agent
      end
    end

    def fetch
      response = conn.get do |req|
        req.url endpoint('current')
        req.params['key'] = user.key
      end
      save response.body
    end

    def peek
      response = conn.get do |req|
        req.url endpoint('next')
        req.params['key'] = user.key
      end
      save response.body
    end

    def submit(filename)
      path = File.join(filename)
      contents = File.read path
      response = conn.post do |req|
        req.url endpoint
        req.headers['Accept'] = 'application/json'
        req.headers['Content-Type'] = 'application/json'
        req.body = {code: contents, key: user.key, path: path}.to_json
      end
      response
    end

    private

    def user_agent
      "github.com/kytrinyx/exercism CLI v#{Exercism::VERSION}"
    end

    def endpoint(action = nil)
      "/api/v1/user/assignments/#{action}".chomp('/')
    end

    def save(body)
      Assignment.save(JSON.parse(body), project_dir)
    end
  end
end

