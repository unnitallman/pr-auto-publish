# pr-auto-merge
A Github Action that automerges pull requests if all the required checks have passed.


## Usage

Create `.github/workflows/pr_auto_merge.yml` with the following content:

```
name: PR-automerge

on: 
  status:
  pull_request:
    types: [ labeled ]

jobs:
  Auto:
    name: Auto-merge
    runs-on: ubuntu-18.04
    steps:
      - uses: bigbinary/pr-auto-merge@v1.0
        if: contains(github.event.pull_request.labels.*.name, 'mergepr')
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

```

Make sure create a token from [https://github.com/settings/tokens/new](https://github.com/settings/tokens/new) and add to `GITHUB_TOKEN` variable in your repo's secrets. 
