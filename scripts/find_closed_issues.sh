# GITHUB_TOKEN=$1
# previous_release_created_at=$(curl -s -H "Authorization: Bearer $GITHUB_TOKEN" "https://api.github.com/repos/${GITHUB_REPOSITORY}/releases/latest" | jq -r '.created_at')
# latest_tag=$(git describe --tags)
# previous_tag=$(git describe --tags $(git rev-list --tags --skip=1 --max-count=1))
# issues=$(curl -s -H "Authorization: Bearer $GITHUB_TOKEN" "https://api.github.com/repos/${GITHUB_REPOSITORY}/issues?state=closed&per_page=100&since=$previous_release_created_at")
# issues_list=""
# while IFS= read -r row; do
#      number=$(echo "$row" | jq -r '.number')
#      title=$(echo "$row" | jq -r '.title')
#      assignees=$(curl -s -H "Authorization: Bearer $GITHUB_TOKEN" "https://api.github.com/repos/${GITHUB_REPOSITORY}/issues/$number" | jq -r '.assignees[].login' | xargs)
#      url=$(echo "$row" | jq -r '.html_url')

#      assignee_links=""
#      for assignee in $assignees; do
#          assignee_links="$assignee_links[@$assignee](https://github.com/$assignee) "
#      done

#      issues_list="${issues_list}- $title in [#$number]($url) by $assignee_links\n"
# done < <(echo "$issues" | jq -c '.[]')
# echo "Issues list: $issues_list"
# release_id=$(curl -s -H "Authorization: Bearer $GITHUB_TOKEN" "https://api.github.com/repos/${GITHUB_REPOSITORY}/releases/tags/$latest_tag" | jq -r '.id')
# curl -X PATCH -H "Authorization: token $GITHUB_TOKEN" -d '{"body": "Whats Changed:\n\n'"$issues_list"'"}' "https://api.github.com/repos/${GITHUB_REPOSITORY}/releases/$release_id"

GITHUB_TOKEN=$1
CURRENT_RELEASE_TAG=$2

previous_release_created_at=$(curl -s -H "Authorization: Bearer $GITHUB_TOKEN" "https://api.github.com/repos/${GITHUB_REPOSITORY}/releases" | jq -r '.[] | "\(.tag_name)\t\(.created_at)"' | sort -k2,2r | awk 'NR==2 {print $2}')
issues=$(curl -s -H "Authorization: Bearer $GITHUB_TOKEN" "https://api.github.com/repos/${GITHUB_REPOSITORY}/issues?state=closed&per_page=100&since=$previous_release_created_at&until=$(date -u +'%Y-%m-%dT%H:%M:%SZ')")

issues_list=""
while IFS= read -r row; do
    number=$(echo "$row" | jq -r '.number')
    title=$(echo "$row" | jq -r '.title')
    assignees=$(curl -s -H "Authorization: Bearer $GITHUB_TOKEN" "https://api.github.com/repos/${GITHUB_REPOSITORY}/issues/$number" | jq -r '.assignees[].login ' | xargs)
    url=$(echo "$row" | jq -r '.html_url')
    assignee_links=""
    for assignee in $assignees; do
        assignee_links="$assignee_links[@$assignee](https://github.com/$assignee) "
    done

    issues_list="${issues_list}- $title in [#$number]($url) by $assignee_links\n"
done < <(echo "$issues" | jq -c '.[]')

release_id=$(curl -s -H "Authorization: Bearer $GITHUB_TOKEN" "https://api.github.com/repos/${GITHUB_REPOSITORY}/releases/tags/$CURRENT_RELEASE_TAG" | jq -r '.id')
curl -X PATCH -H "Authorization: token $GITHUB_TOKEN" -d '{"body": "Whats Changed:\n\n'"$issues_list"'"}' "https://api.github.com/repos/${GITHUB_REPOSITORY}/releases/$release_id"