#!/usr/bin/env bats

load test_helper

# `notes init` ################################################################

@test "\`init\` exits with status 0." {
  run "$_NOTES" init
  [[ $status -eq 0 ]]
}

@test "\`init\` exits with status 1 when \$NOTES_DIR exists as a file." {
  touch "${NOTES_DIR}"
  [[ -e "${NOTES_DIR}" ]]
  run "$_NOTES" init
  [[ $status -eq 1 ]]
}

@test "\`init\` exits with status 1 when \$NOTES_DATA_DIR exists." {
  mkdir -p "${NOTES_DATA_DIR}"
  [[ -e "${NOTES_DATA_DIR}" ]]
  run "$_NOTES" init
  [[ $status -eq 1 ]]
}

@test "\`init\` creates \`\$NOTES_DIR\` and \`\$NOTES_DATA_DIR\` directories." {
  run "$_NOTES" init
  [[ -d "${NOTES_DIR}" ]]
  [[ -d "${NOTES_DATA_DIR}" ]]
}

@test "\`init\` creates a git directory in \`\$NOTES_DATA_DIR\`." {
  run "$_NOTES" init
  [[ -d "${NOTES_DATA_DIR}/.git" ]]
}

# `notes init <remote-url>` ###################################################

@test "\`init <remote-url>\` creates a clone in \`\$NOTES_DATA_DIR\`." {
  _setup_remote_repo
  run "$_NOTES" init "$_GIT_REMOTE_URL"
  [[ -d "${NOTES_DATA_DIR}/.git" ]]
  _origin="$(cd "${NOTES_DATA_DIR}" && git config --get remote.origin.url)"
  _compare "$_GIT_REMOTE_URL" "$_origin"
  [[ "$_origin" =~  "$_GIT_REMOTE_URL" ]]
}
