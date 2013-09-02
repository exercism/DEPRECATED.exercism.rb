class Exercism
  class CLI
    class MonitoredRequest
      attr_reader :api

      def initialize(api)
        @api = api
      end

      def request(action, *args)
        begin
          response = api.send(action, *args)
          response_body = JSON.parse(response.body)

          abort response_body["error"] if response_body["error"]

          yield response, response_body
        rescue Exception => e
          abort "There was an issue with your request.\n#{e}"
        end
      end
    end
  end
end