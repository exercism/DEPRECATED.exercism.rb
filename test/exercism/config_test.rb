require './test/test_helper'

class ConfigTest < Minitest::Test

  def path
    './test/fixtures'
  end

  def data
    { 
      'github_username' => 'bob', 
      'key' => '7a7096c',
      'project_dir' => '/tmp'
    }
  end

  def key
    data['key']
  end

  def write_config_file(path, info = {})
    Exercism::Config.write(path, data.merge!(info))
  end

  def teardown
    if File.exists?('./test/fixtures/.exercism')
      FileUtils.rm('./test/fixtures/.exercism')
    end

    if File.exists?('./test/fixtures/.config/exercism')
      FileUtils.rm_r('./test/fixtures/.config')
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

  def test_reads_from_alternate_path_config_file_when_config_file_in_default_path_is_missing
    write_config_file('./test/fixtures/.config')
    Exercism::Config.stub(:alternate_path, './test/fixtures/.config') do
      config = Exercism::Config.read(path)
      assert_equal 'bob', config.github_username
      assert_equal key, config.key
      assert_equal '/tmp', config.project_dir  
    end
  end

  def test_write_config_file
    config = write_config_file(path)
    assert_equal 'bob', config.github_username
    assert_equal key, config.key
    assert_equal '/tmp', config.project_dir
  end

  def test_delete_config_file
    config = write_config_file(path)
    filename = config.file
    config.delete
    assert !File.exists?(filename)
  end

  def test_write_directory_if_missing
    data = {'project_dir' => './test/fixtures/some/project/dir'}
    write_config_file(path, data)
    assert File.exist?(data['project_dir'])
  end

end
