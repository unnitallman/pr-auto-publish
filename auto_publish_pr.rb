require 'octokit'
require_relative 'src/github_graphql'
require_relative 'src/pull_request'
require_relative 'src/mark_pull_request_as_ready_for_review'

client = Octokit::Client.new(access_token: ENV["GITHUB_TOKEN"])

owner,repo = ENV["GITHUB_REPOSITORY"].split("/")
pr_number  = ENV["GITHUB_REF"].split("/")[2].to_i

if GithubGraphql::PullRequest.ready_for_review?(owner, repo, pr_number)
  pr = GithubGraphql::PullRequest.find(owner, repo, pr_num)
  GithubGraphql::MarkPullRequestAsReadyForReview.mark!(pr.id)
  exit(0)
end

puts %{
  PR not marked as Ready-For-Review. 
  Make sure all checks have passed and the review app is deployed successfully.
}
exit(1)