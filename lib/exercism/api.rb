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
      end
    end

    def fetch
      response = conn.get do |req|
        req.url '/api/v1/user/assignments/current'
        req.headers['User-Agent'] = "exercism-CLI v#{Exercism::VERSION}"
        req.params['key'] = user.key
      end
      Assignment.save(JSON.parse(response.body), project_dir)
    end

    def submit(filename)
      path = File.join(filename)
      contents = File.read path
      response = conn.post do |req|
        req.url '/api/v1/user/assignments'
        req.headers['Accept'] = 'application/json'
        req.headers['Content-Type'] = 'application/json'
        req.headers['User-Agent'] = "exercism-CLI v#{Exercism::VERSION}"
        req.body = {code: contents, key: user.key, path: path}.to_json
      end
      response
    end
  end
end

