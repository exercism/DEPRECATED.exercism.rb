require './test/test_helper'

class ExercismTest < Minitest::Test

  def teardown
    if File.exists?('./test/fixtures/.exercism')
      FileUtils.rm('./test/fixtures/.exercism')
    end
  end

  def test_logged_in_user
    Exercism.stub(:home, './test/fixtures/home') do
      user = Exercism.user
      key = '634abfb095ed621e1c793c9875fcd9fda455ea90'
      assert_equal 'alice', user.github_username
      assert_equal key, user.key
    end
  end

  def test_login_writes_the_config_file
    home = './test/fixtures'
    Exercism.stub(:home, home) do
      key = '97e9975'
      Exercism.login('bob', key, '/tmp', home)
      user = Exercism.user
      assert_equal 'bob', user.github_username
      assert_equal key, user.key
    end
  end
end

