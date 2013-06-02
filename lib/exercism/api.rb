class Exercism
  class Api
    def self.fetch_for(user)
      conn = Faraday.new(:url => Exercism.url) do |c|
        c.use Faraday::Adapter::NetHttp
      end

      response = conn.get do |req|
        req.url '/api/v1/user/assignments/current'
        req.headers['User-Agent'] = 'exercism-CLI v0.0.1.pre-alpha'
        req.params['key'] = user.key
      end
      assignment = Assignment.new(JSON.parse(response.body))
      assignment.save
    end
  end
end

