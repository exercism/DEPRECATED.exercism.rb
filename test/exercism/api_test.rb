require './test/test_helper'

require 'vcr'

test_dir = File.join(FileUtils.pwd, 'test/fixtures')

VCR.configure do |c|
  c.cassette_library_dir = File.join(test_dir, 'vcr_cassettes')
  c.hook_into :fakeweb
end

require 'approvals'
Approvals.configure do |c|
  c.approvals_path = File.join(test_dir, 'approvals') + '/'
end

class ApiTest < MiniTest::Unit::TestCase

  def setup
    @project_dir = FileUtils.pwd
  end

  def teardown
    FileUtils.cd @project_dir
    FileUtils.rm_rf File.join(@project_dir, 'test/fixtures/home/ruby')
  end

  def test_fetch_assignment_from_api
    home = File.join(@project_dir, 'test/fixtures/home')
    readme_path = File.join(home, 'ruby/bob/README.md')
    tests_path = File.join(home, 'ruby/bob/test.rb')

    Exercism.stub(:home, home) do
      FileUtils.cd home
      VCR.use_cassette('alice-gets-bob') do
        Exercism::Api.fetch_for(Exercism.user)

        Approvals.verify(File.read(readme_path), name: 'alice_gets_bob_readme')
        Approvals.verify(File.read(tests_path), name: 'alice_gets_bob_tests')
      end
    end
  end

  def test_send_assignment_to_api
    home = File.join(@project_dir, 'test/fixtures/home')
    assignment_path = File.join(home, 'ruby/bob')
    FileUtils.mkdir_p(assignment_path)
    submission = File.join(assignment_path, 'bob.rb')
    File.open(submission, 'w') do |f|
      f.write "puts 'hello world'"
    end

    Exercism.stub(:home, home) do
      FileUtils.cd assignment_path
      VCR.use_cassette('alice-submits-bob') do
        response = Exercism::Api.submit('bob.rb', {for: Exercism.user})
        assert_equal 201, response.status
      end
    end
  end

end
