#!/bin/bash

ORG="bit-faas"
REPO="$1"
ADMIN_USER="$2"
TOKEN="$3"

curl -X PUT \
  -H "Authorization: token $TOKEN" \
  -H "Accept: application/vnd.github+json" \
  https://api.github.com/repos/$ORG/$REPO/branches/main/protection \
  -d '{
    "required_status_checks": {
      "strict": true,
      "contexts": ["jenkins-ci"]
    },
    "enforce_admins": true,
    "required_pull_request_reviews": {
      "dismiss_stale_reviews": true,
      "require_last_push_approval": true,
      "required_approving_review_count": 1
    },
    "restrictions": {
      "users": ["'"$ADMIN_USER"'"],
      "teams": []
    },
    "allow_force_pushes": false,
    "allow_deletions": false
  }'
