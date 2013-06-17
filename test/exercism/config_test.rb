require './test/test_helper'

class ConfigTest < MiniTest::Unit::TestCase

  def path
    './test/fixtures'
  end

  def key
    '7a7096c'
  end

  def teardown
    if File.exists?('./test/fixtures/.exercism')
      FileUtils.rm('./test/fixtures/.exercism')
    end

    if File.exists?('./test/fixtures/some/project/dir')
      FileUtils.rm_r('./test/fixtures/some')
    end
  end

  def test_read_config_file
    config = Exercism::Config.read('./test/fixtures/home')
    assert_equal 'alice', config.github_username
    assert_equal '634abfb095ed621e1c793c9875fcd9fda455ea90', config.key
    assert_equal '/tmp', config.project_dir
  end

  def test_write_config_file
    data = {
      'github_username' => 'bob',
      'key' => key,
      'project_dir' => '/tmp'
    }
    config = Exercism::Config.write(path, data)
    assert_equal 'bob', config.github_username
    assert_equal key, config.key
    assert_equal '/tmp', config.project_dir
  end

  def test_delete_config_file
    data = {
      'github_username' => 'bob',
      'key' => key,
      'project_dir' => '/tmp'
    }
    config = Exercism::Config.write(path, data)
    filename = config.file
    config.delete
    assert !File.exists?(filename)
  end

  def test_write_directory_if_missing
    project_dir = './test/fixtures/some/project/dir'
    data = {
      'github_username' => 'bob',
      'key' => key,
      'project_dir' => project_dir
    }
    Exercism::Config.write(path, data)
    assert File.exist? project_dir
  end

end
