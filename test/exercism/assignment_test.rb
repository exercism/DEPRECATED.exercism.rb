require './test/test_helper'

class AssignmentTest < MiniTest::Unit::TestCase

  def setup
    @project_dir = FileUtils.pwd
  end

  def teardown
    FileUtils.cd @project_dir
    FileUtils.rm_rf File.join(@project_dir, 'test/fixtures/ruby')
  end

  def readme_path
    File.join(@project_dir, 'test/fixtures/ruby/queens/README.md')
  end

  def tests_path
    File.join(@project_dir, 'test/fixtures/ruby/queens/test.rb')
  end

  def assignment_data
    {
      'track' => 'ruby',
      'slug' => 'queens',
      'readme' => 'Do it',
      'testfile' => 'test.rb',
      'tests' => 'assert true'
    }
  end

  def test_write_assignment_from_project_directory
    FileUtils.cd 'test/fixtures'
    assignment = Exercism::Assignment.new(assignment_data)
    assignment.save

    assert_equal "Do it", File.read(readme_path)
    assert_equal "assert true", File.read(tests_path)
  end

  def test_write_assignment_from_language_directory
    FileUtils.mkdir File.join(@project_dir, 'test/fixtures/ruby')
    FileUtils.cd 'test/fixtures/ruby'
    assignment = Exercism::Assignment.new(assignment_data)
    assignment.save

    assert_equal "Do it", File.read(readme_path)
    assert_equal "assert true", File.read(tests_path)
  end
end

