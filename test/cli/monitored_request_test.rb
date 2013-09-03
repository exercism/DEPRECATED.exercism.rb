require './test/test_helper'
require 'cli/monitored_request'

Struct.new('Response', :body)

class MonitoredRequestTest < MiniTest::Unit::TestCase
  def setup
    setup_api
    @monitored_request = Exercism::CLI::MonitoredRequest.new(@api)
  end

  def test_yield
    @monitored_request.request :success_action do |response, body|
      assert_equal 'Hi.', body["message"]
    end
  end

  def test_response_errors
    out, err = capture_subprocess_io do
      pid = fork { @monitored_request.request :failure_action }
      Process.wait pid
    end

    assert_match 'Error.', err
  end

  def test_handle_request_exceptions
    out, err = capture_subprocess_io do
      pid = fork { @monitored_request.request :exception_action }
      Process.wait pid
    end

    assert_match 'There was an issue with your request.', err
  end

  private

  def setup_api
    @api = Minitest::Mock.new

    def @api.failure_action
      Struct::Response.new('{"error":"Error."}')
    end

    def @api.success_action
      Struct::Response.new('{"message":"Hi."}')
    end

    def @api.exception_action
      raise Exception
    end
  end
end