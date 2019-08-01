workflow "Commit Push" {
  on = "push"
  resolves = ["nexmo/github-actions/submodule-auto-pr@master"]
}

action "nexmo/github-actions/submodule-auto-pr@master" {
  uses = "nexmo/github-actions/submodule-auto-pr@master"
  secrets = ["GH_ADMIN_TOKEN"]
  env = {
    PR_TARGET_ORG = "nexmo"
    PR_TARGET_REPO = "nexmo-developer"
    PR_SUBMODULE_PATH = "_documentation/client-sdk/sdk-documentation"
    PR_BRANCH_NAME = "automated-docs-update"
    PR_TITLE = "Docs Specification Update"
    PR_TARGET_BRANCH = "master"
    PR_ACTIVE_BRANCH = "master"
  }
}

workflow "PR Edited" {
  resolves = ["Create Review App"]
  on = "pull_request"
}

action "Create Review App" {
  uses = "docker://mheap/github-action-pr-heroku-review-app"
  secrets = [
    "GITHUB_TOKEN",
    "HEROKU_AUTH_TOKEN",
    "HEROKU_APPLICATION_ID",
  ]
}

workflow "New release" {
  on = "release"
  resolves = ["Add Changelog"]
}

action "Add Changelog" {
  uses = "nexmo/github-actions/nexmo-changelog@master"
  secrets = ["CHANGELOG_AUTH_TOKEN"]
  env = {
    CHANGELOG_CATEGORY = "Client SDK"
    CHANGELOG_SUBCATEGORY = "javascript"
  }
}
