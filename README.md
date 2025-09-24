<p align='center'>
  <img alt='namae-no-eda logo' src='./assets/logo-shrk-cmpr.png' />
</p>

<h1 align='center'>namae-no-eda (名前の枝, "branch name")</h1>
<p align='center'>Keep your branch names tidy, like leaves on a tree</p>

<p align='center'>
  <img alt='haiku' src='./assets/haiku-cmpr.png' width='250px' />
</p>

## Example

This workflow validates branch names using `namae-no-eda`.  
By default it allows:  
`feat/*, fix/*, chore/*, docs/*, refactor/*, test/*, perf/*`  
and excludes:  
`main, release/*`.

```yaml
name: Branch Lint
on:
  pull_request:
    branches:
      - '**'
  push:
    branches:
      - '**'

jobs:
  branch-lint:
    runs-on: ubuntu-latest
    steps:
      - name: Check out repository
        uses: actions/checkout@v4

      - name: Validate branch name
        uses: dcdavidev/namae-no-eda@v0.0.1 # Check latest release first.
        # with:
        #   allowed: 'fix/*,feature/*,release/*' # Optional
        #   exclude: 'main,develop' # Optional
```

## How it works

- **allowed** _(optional)_: Comma-separated glob patterns. Defaults to `feat/*,fix/*,chore/*,docs/*,refactor/*,test/*,perf/*`.
- **exclude** _(optional)_: Comma-separated exact branch names. Defaults to `main,release/*`.
- **branch_name** _(optional)_: Branch to check. Defaults to the branch that triggered the workflow.

If the branch name does not match any allowed patterns and is not excluded, the action will fail the workflow.

## Code Reviews

![CodeRabbit Pull Request Reviews](https://img.shields.io/coderabbit/prs/github/dcdavidev/namae-no-eda?utm_source=oss&utm_medium=github&utm_campaign=dcdavidev%2Fnamae-no-eda&labelColor=171717&color=FF570A&link=https%3A%2F%2Fcoderabbit.ai&label=CodeRabbit+Reviews)

## 📄 License

This repository is licensed under the MIT License.
