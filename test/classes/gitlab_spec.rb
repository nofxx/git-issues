require 'minitest_helper'

describe RepoProvider::Gitlab do
  before :each do
    @gh = RepoProvider::Gitlab.new
  end

  it "should get repository" do
    md = RepoProvider::Gitlab.get_repo('git@gitlab.com:lucretia/dog-issues.git')
    md['user'].must_equal 'lucretia'
    md['repo'].must_equal 'dog-issues'
  end

  it "should get custom repository" do
    md = RepoProvider::Gitlab.get_repo('git@doggit.com:lucretia/dog-issues.git')
    md['user'].must_equal 'lucretia'
    md['repo'].must_equal 'dog-issues'
  end

  it "should get custom repository gitlab user" do
    md = RepoProvider::Gitlab.get_repo('gitlab@doggit.com:lucretia/dog-issues.git')
    md['user'].must_equal 'lucretia'
    md['repo'].must_equal 'dog-issues'
  end
end
