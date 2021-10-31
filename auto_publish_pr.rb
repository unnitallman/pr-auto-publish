require 'octokit'
require_relative 'src/github_graphql'
require_relative 'src/pull_request'
require_relative 'src/enable_pr_auto_merge'

client = Octokit::Client.new(access_token: ENV["GITHUB_TOKEN"])

owner,repo = ENV["GITHUB_REPOSITORY"].split("/")
pr_number  = ENV["GITHUB_REF"].split("/")[2].to_i

checks_status = client.status(ENV["GITHUB_REPOSITORY"], ENV["GITHUB_HEAD_REF"])[:state]

# if status checks are still pending
if checks_status == "pending"
  pr_id = GithubGraphql::PullRequest.find(owner, repo, pr_number).id
  GithubGraphql::EnablePRAutoMerge.mark! pr_id
  exit(0)
end

# if status checks have already completed and is successs
if checks_status == "success"
  client.merge_pull_request(ENV["GITHUB_REPOSITORY"], pr_number, "", {merge_method: "squash"})
  exit(0)
end

puts "Automerge stopped. Please make sure all checks have passed"
exit(1)