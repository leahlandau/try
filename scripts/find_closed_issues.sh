GITHUB_TOKEN=$1
CURRENT_RELEASE_PATH=$2
URL="https://api.github.com/repos/${GITHUB_REPOSITORY}"

previous_release_created_at=$(curl -s -H "Authorization: Bearer $GITHUB_TOKEN" "$URL/releases" | jq -r '.[1] | .created_at')
issues=$(curl -s -H "Authorization: Bearer $GITHUB_TOKEN" "$URL/issues?state=closed&per_page=100&since=$previous_release_created_at&until=$(date -u +'%Y-%m-%dT%H:%M:%SZ')")
issue_list=$(echo "$issues" | jq -r '.[] | "- \(.title) in [#\(.number)](\(.html_url)) by [@\(.assignee.login )](https://github.com/\(.assignee.login))"' | paste -sd '\n')

curl -X PATCH -H "Authorization: Bearer $GITHUB_TOKEN" -d "$(jq -n --arg body $'Whats Changed:\n'"$issue_list" '{body: $body | gsub(" - "; "\n")}' )" "$CURRENT_RELEASE_PATH"