require 'minitest_helper'

describe RepoProvider::Github do
  before :each do
    @gh = RepoProvider::Github.new
  end

  it "should get repository.git" do
    md = RepoProvider::Github.get_repo('git@github.com:lucretia/dog-issues.git')
    md['user'].must_equal 'lucretia'
    md['repo'].must_equal 'dog-issues'
  end

  it "should get repository w/o .git" do
    md = RepoProvider::Github.get_repo('git@github.com:lucretia/dog-issues')
    md['user'].must_equal 'lucretia'
    md['repo'].must_equal 'dog-issues'
  end

  it "should get repository  https" do
    md = RepoProvider::Github.get_repo('https://github.com/lucretia/dog-issues.git')
    md['user'].must_equal 'lucretia'
    md['repo'].must_equal 'dog-issues'
  end
end
