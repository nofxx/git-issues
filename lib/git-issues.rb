require 'git-issues/version'
require 'git-issues/providers'

require 'parseconfig'
require 'rainbow'
require 'zlog'

class GitIssues
  Log = Logging.logger[self]

  attr_reader :providers
  def initialize
    @providers = RepoProviders.new
  end

  def gitReposFor uri
    path = File.expand_path(uri)
    git_path = File.join(path, '.git')
    git_conf = File.join(git_path, 'config')

    if not File.directory?(git_path)
      Log.error "This is not a git repository (path: #{path})"
      return []
    end

    if not File.file?(git_conf)
      Log.error "Missing git configuration file (missing: #{git_conf})"
      return []
    end

    config = ParseConfig.new(git_conf)

    remotes = config.params.keys.find_all { |i| i.start_with?('remote ') }
    remote_repos = remotes.map { |r| config.params[r]['url'] }

    @providers.map_urls_to_provider remote_repos
  end

end
