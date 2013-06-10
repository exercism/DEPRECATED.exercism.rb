class Exercism
  class Api
    def self.conn
     conn = Faraday.new(:url => Exercism.url) do |c|
        c.use Faraday::Adapter::NetHttp
      end
    end

    def self.fetch_for(user)
      response = conn.get do |req|
        req.url '/api/v1/user/assignments/current'
        req.headers['User-Agent'] = "exercism-CLI v#{Exercism::VERSION}"
        req.params['key'] = user.key
      end
      Assignment.save(JSON.parse(response.body))
    end

    def self.submit(filename, options)
      user = options[:for]
      path = File.join(FileUtils.pwd, filename)
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

