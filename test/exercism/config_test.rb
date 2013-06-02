require './test/test_helper'

class ConfigTest < MiniTest::Unit::TestCase

  def teardown
    if File.exists?('./test/fixtures/.exercism')
      FileUtils.rm('./test/fixtures/.exercism')
    end
  end

  def test_read_config_file
    path = './test/fixtures/home'
    key = '634abfb095ed621e1c793c9875fcd9fda455ea90'
    config = Exercism::Config.read(path)
    assert_equal 'alice', config.github_username
    assert_equal key, config.key
  end

  def test_write_config_file
    path = './test/fixtures'
    key = '7a7096c'
    data = {'github_username' => 'bob', 'key' => key}
    config = Exercism::Config.write(path, data)
    assert_equal 'bob', config.github_username
    assert_equal key, config.key
  end

  def test_delete_config_file
    path = './test/fixtures'
    key = '7a7096c'
    data = {'github_username' => 'bob', 'key' => key}
    config = Exercism::Config.write(path, data)
    filename = config.file
    config.delete
    assert !File.exists?(filename)
  end

end
