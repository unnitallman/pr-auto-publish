module GithubGraphql
  class PullRequest
    PullRequestQuery = GithubGraphql::Client.parse <<-'GRAPHQL'
      query($owner: String!, $repo: String!, $pull_number: Int!) {
        repository(owner: $owner, name:$repo) {
          pullRequest(number:$pull_number) {
            id
            commits(last: 1) {
              nodes {
                commit {
                  deployments(last:1){
                    nodes {
                      state
                    }
                  }
                  statusCheckRollup{
                    state
                  }
                  author {
                    name
                  }
                  status {
                    state
                  }
                }
              }
            }
          }
        }
      }
    GRAPHQL

    def self.find(owner, repo, pr_num)
      response = GithubGraphql::Client.query(PullRequestQuery, variables: { pull_number: pr_num, owner: owner, repo: repo })
      if response.errors.any?
        raise QueryExecutionError.new(response.errors[:data].join(", "))
      else
        response.data.repository.pull_request
      end
    end

    def self.ready_for_review?(owner, repo, pr_num)
      pr = find(owner, repo, pr_num)  
      checks_status     = pr.commits.nodes.first.commit.status.state
      deployment_status = pr.commits.nodes.first.commit.deployments.nodes.first.state

      checks_status == "SUCCESS" && deployment_status == "ACTIVE"
    end
  end
end