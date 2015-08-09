require 'gitlab'

# API documentation:
# http://api.gitlab.org/

class RepoProvider::Gitlab

  URL_PATTERNS = [
    /^(ssh:\/\/)?git(lab)?@(?<host>[^:]*):(?<user>[^\/]+)\/(?<repo>.+)\.git$/
  ]

  def self.get_repo url
    # find the url pattern that matches the url
    URL_PATTERNS.map{|p| p.match url }.compact.first
  end

  def issues_list opts = {}
    issues = gitlab.issues gl_project_id
    # filter out closed issues if desired
    issues = issues.find_all { |i| i.state != 'closed' } if !opts[:all]
    # return issues
    format_issues issues
  end

  def issue_create title, content
    gitlab.create_issue gl_project_id, title, description: content
  end

  def issue_reopen id
    gitlab.reopen_issue gl_project_id, id
  end

  def issue_close id
    gitlab.close_issue gl_project_id, id
  end

  def issue_delete id
    log.warn "You can't delete issues on Gitlab anymore, it is deprecated. Please close/resolve them instead."
  end

  def provider
    gitlab
  end

  private

  def format_issues is
    Array(is).map do |i|
      assignee = i.assignee && i.assignee.username
      {
        'number'      => i.iid,
        'title'       => i.title,
        'description' => i.description,
        'state'       => i.state,
        'labels'      => i.labels,
        'updated_at'  => Date.parse(i.updated_at),
        'author'      => i.author.username,
        'assignee'    => assignee,
      }
    end
  end

  def find_project
    path = "#{repo['user']}/#{repo['repo']}"
    p = gitlab.projects(per_page: 100).find { |p| p.path_with_namespace == path}
    log.info "using project id = #{p.id} (#{p.path_with_namespace})" if !p.nil?
    (p.nil?) ? nil : p.id
  end

  def gl_project_id
    @gl_project_id ||= find_project
  end

  # Defaults to HTTPS
  def init_gitlab
    ot = oauth_token
    url = "https://#{repo['host']}/api/v3"
    Gitlab.client endpoint: url, private_token: ot
  end

  def gitlab
    @gitlab ||= init_gitlab
  end

end
