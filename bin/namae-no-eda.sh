#!/usr/bin/env bash
set -euo pipefail

# Defaults
DEFAULT_ALLOWED="feat/*,fix/*,chore/*,docs/*,refactor/*,test/*,perf/*"
DEFAULT_EXCLUDE="main,release/*"

# Determine the branch name
get_branch_name() {
  local branch="${INPUT_BRANCH_NAME:-}"

  if [[ -z "$branch" ]]; then
    branch="${GITHUB_HEAD_REF:-}"
    if [[ -z "$branch" && -n "${GITHUB_REF:-}" ]]; then
      branch="${GITHUB_REF#refs/heads/}"
    fi
  fi

  if [[ -z "$branch" ]]; then
    echo "[FATAL] ❌ Could not determine branch name."
    echo "👹 Lost branch drifts, no tree remembers it."
    return 1
  fi

  echo "$branch"
}

# Convert CSV string to array
csv_to_array() {
  local csv="${1-}"
  local IFS=',' parts=()
  read -r -a parts <<< "$csv"
  local out=()
  for tok in "${parts[@]}"; do
    tok="${tok#"${tok%%[![:space:]]*}"}"
    tok="${tok%"${tok##*[![:space:]]}"}"
    [[ -n "$tok" ]] && out+=("$tok")
  done
  printf '%s\0' "${out[@]}"
}

in_array() {
  local val="$1"
  shift
  for e in "$@"; do
    [[ "$e" == "$val" ]] && return 0
  done
  return 1
}

glob_match_any() {
  local name="$1"
  shift
  for pat in "$@"; do
    # shellcheck disable=SC2053
    [[ "$name" == $pat ]] && return 0
  done
  return 1
}

validate_branch() {
  local branch="$1"
  shift

  local -a exclude=()
  local -a allowed=()
  local i=0

  for arg in "$@"; do
    if [[ "$arg" == "__SEP__" ]]; then
      i=1
      continue
    fi
    if [[ $i -eq 0 ]]; then
      exclude+=("$arg")
    else
      allowed+=("$arg")
    fi
  done

  if glob_match_any "$branch" "${exclude[@]}"; then
    echo "[OK] ✅ Branch '$branch' is excluded from checks."
    echo "🌸 Quiet roots shelter forgotten branches."
    return 0
  fi

  if glob_match_any "$branch" "${allowed[@]}"; then
    echo "[OK] ✅ Branch '$branch' matches an allowed pattern."
    echo "🌸 Flowing stream guides each name downstream."
    return 0
  fi

  echo "[ERROR] ❌ Invalid branch name: $branch"
  echo "   Must match one of the allowed patterns: ${allowed[*]}"
  echo "👹 Oni grins—chaos blooms from broken names."
  return 1
}

main() {
  branch=$(get_branch_name) || exit 1

  mapfile -d '' -t exclude < <(csv_to_array "${INPUT_EXCLUDE:-$DEFAULT_EXCLUDE}")
  mapfile -d '' -t allowed < <(csv_to_array "${INPUT_ALLOWED:-$DEFAULT_ALLOWED}")

  validate_branch "$branch" "${exclude[@]}" "__SEP__" "${allowed[@]}" || exit 1
}

main
