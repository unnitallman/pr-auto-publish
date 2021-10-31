# pr-auto-publish
A Github Action that automatically marks a Draft PR as Read-for-Review if one or more checks have passed. 


## Usage

Create `.github/workflows/pr_auto_publish.yml` with the following content:

```
name: PR-autopublish

on: 
  status:
  pull_request:
    types: [ labeled ]

jobs:
  Auto:
    name: Auto-merge
    runs-on: ubuntu-18.04
    steps:
      - uses: unnitallman/pr-auto-publish@v0.1
        if: contains(github.event.pull_request.labels.*.name, 'makepr')
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

```

Create a token from [https://github.com/settings/tokens/new](https://github.com/settings/tokens/new) and add to `GITHUB_TOKEN` variable in your repo's secrets. 
