module GithubGraphql
  class EnablePRAutoMerge
    EnablePRAutoMergeMutation = GithubGraphql::Client.parse <<-'GRAPHQL'
      mutation($prid: ID!, $cmid: String!){
        enablePullRequestAutoMerge(input: {mergeMethod:SQUASH, pullRequestId: $prid, clientMutationId: $cmid}){
          clientMutationId
        }
      }
    GRAPHQL

    def self.mark!(pr_id)
      response = GithubGraphql::Client.query(EnablePRAutoMergeMutation, variables: { prid: pr_id, cmid: Time.now.to_i.to_s })
      if response.errors.any?
        raise QueryExecutionError.new(response.errors[:data].join(", "))
      else
        response.data
      end
    end
  end
end