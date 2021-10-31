module GithubGraphql
  class PullRequest
    PullRequestQuery = GithubGraphql::Client.parse <<-'GRAPHQL'
      query($owner: String!, $repo: String!, $pull_number: Int!) {
        repository(owner: $owner, name:$repo) {
          pullRequest(number:$pull_number) {
            id
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
  end
end