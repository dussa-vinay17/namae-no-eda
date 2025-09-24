#!/usr/bin/env bats
# shellcheck shell=bash

load 'test_helper/bats-assert/load.bash'

setup() {
  export GITHUB_ACTION_PATH="$PWD"
  export PATH="$GITHUB_ACTION_PATH/bin:$PATH"
}

branch_tests=(
  "feat/awesome|0"
  "fix/bug|0"
  "chore/update|0"
  "docs/readme|0"
  "refactor/code|0"
  "test/my-test|0"
  "perf/speed|0"
  "main|0"
  "release/1.0.0|0"
  "weird/branch|1"
  "hotfix/urgent|1"
  "experimental/foo|1"
)

@test "branch name validation (allowed/excluded/invalid)" {
  for entry in "${branch_tests[@]}"; do
    IFS="|" read -r branch expected_status <<< "$entry"

    echo -e "\nTesting branch: $branch …"

    run env INPUT_BRANCH_NAME="$branch" bin/namae-no-eda.sh

    if [[ "$expected_status" -eq 0 ]]; then
      assert_success
      assert_output --partial "[OK]"
      assert_output --partial "🌸"
      echo -e "  ✅ Passed"
    else
      assert_failure
      assert_output --partial "[ERROR]"
      assert_output --partial "👹"
      echo -e "  ❌ Failed"
    fi
  done
}
