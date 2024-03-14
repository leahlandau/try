GITHUB_TOKEN=$1
CURRENT_RELEASE_PATH=$2

URL="https://api.github.com/repos/${GITHUB_REPOSITORY}"
AUTHORIZE="Authorization: Bearer $GITHUB_TOKEN"
CURLARGS="-s -H"
# API_PATH=`curl -s -H "Authorization: Bearer $GITHUB_TOKEN" "https://api.github.com/repos/${GITHUB_REPOSITORY}"`
previous_release_created_at=$(curl $CURLARGS $AUTHORIZE `$URL/releases` | jq -r '.[] | "\(.tag_name)\t\(.created_at)"' | sort -k2,2r | awk 'NR==2 {print $2}')
issues=$(curl $CURLARGS $AUTHORIZE `$URL/issues?state=closed&per_page=100&since=$previous_release_created_at&until=$(date -u +'%Y-%m-%dT%H:%M:%SZ')`)
issues_list=""
while IFS= read -r row; do
    number=$(echo "$row" | jq -r '.number')
    title=$(echo "$row" | jq -r '.title')
    assignees=$(curl $CURLARGS $AUTHORIZE `$URL/issues/$number` | jq -r '.assignees[].login ' | xargs)
    url=$(echo "$row" | jq -r '.html_url')
    assignee_links=""
    for assignee in $assignees; do
        assignee_links="$assignee_links[@$assignee](https://github.com/$assignee) "
    done
    issues_list="${issues_list}- $title in [#$number]($url) by $assignee_links\n"
done < <(echo "$issues" | jq -c '.[]')
curl -X PATCH -H $AUTHORIZE -d '{"body": "Whats Changed:\n\n'"$issues_list"'"}' "$CURRENT_RELEASE_PATH"