GITHUB_TOKEN=$1
CURRENT_RELEASE_PATH=$2
URL="https://api.github.com/repos/${GITHUB_REPOSITORY}"
AUTHORIZE="Authorization: Bearer $GITHUB_TOKEN"
CURLARGS="-s -H"
echo $(curl $CURLARGS "$AUTHORIZE" "$URL/releases" | jq -r '.[] | "\(.tag_name)\t\(.created_at)"' | sort -k2,2r)
previous_release_created_at=$(curl $CURLARGS "$AUTHORIZE" "$URL/releases" | jq -r '.[] | "\(.tag_name)\t\(.created_at)"' | sort -k2,2r | awk 'NR==2 {print $2}')
echo $previous_release_created_at
issues=$(curl $CURLARGS "$AUTHORIZE" "$URL/issues?state=closed&per_page=100&since=$previous_release_created_at&until=$(date -u +'%Y-%m-%dT%H:%M:%SZ')")
# issues_list=""
# while IFS= read -r row; do
#     number=$(echo "$row" | jq -r '.number')
#     title=$(echo "$row" | jq -r '.title')
#     assignees=$(curl $CURLARGS "$AUTHORIZE" "$URL/issues/$number" | jq -r '.assignees[].login ' | xargs)
#     url=$(echo "$row" | jq -r '.html_url')
#     assignee_links=""
#     for assignee in $assignees; do
#         assignee_links="$assignee_links[@$assignee](https://github.com/$assignee) "
#     done
#     issues_list="${issues_list}- $title in [#$number]($url) by $assignee_links\n"
# done < <(echo "$issues" | jq -c '.[]')

# curl -X PATCH -H "$AUTHORIZE" -d '{"body": "Whats Changed:\n\n'"$issues"'"}' "$CURRENT_RELEASE_PATH"
curl -X PATCH -H "$AUTHORIZE" -d "{\"body\": \"Whats Changed:\\n\\n$(echo "$issues" | jq -r '.[] | \"- \(.title) in [#\(.number)](\(.html_url)) by \(.assignees[].login | \"[@\" + . + \"](https://github.com/\" + . + \")\")' | paste -sd '\n' -)\"}" "$CURRENT_RELEASE_PATH"
          # curl -X PATCH -H "$AUTHORIZE" -d "{\"body\": \"Whats Changed:\\n\\n$(echo "$issues" | jq -r '.[] | \"- \(.title) in [#\(.number)](\(.html_url)) by \(.assignees[].login | \"[@\" + . + \"](https://github.com/\" + . + \")\")' | paste -sd '\n' -)\"}" "$CURRENT_RELEASE_PATH"name: Update Release Description
  
        #   issue_list=$(echo "$issues" | jq -r '.[] | "- \(.title) in [#\(.number)](\(.html_url)) by \(.assignees[].login | "[@" + . + "](https://github.com/" + . + ")")' | paste -sd '\n' -)

# #################################################################################################################################
# issue_list=$(echo "$issues" | jq -r '.[] | "- \(.title) in [#\(.number)](\(.html_url)) by [@\(.assignee.login)](https://github.com/\(.assignee.login))"' | paste -sd '\n' -)
# previous_release_created_at=$(curl -s -H "$AUTHORIZE" "$URL/releases" | jq -r '.[1] | .created_at')
# issue_list=$(echo "$issues" | jq -r '.[] | "- \(.title) in [#\(.number)](\(.html_url)) by \(.user.login)"' | paste -sd '\n' -)
#################################################################################################################################
    #  URL="https://api.github.com/repos/${{ github.repository }}"
    #       AUTHORIZE="Authorization: Bearer $GITHUB_TOKEN"
    #       CURRENT_RELEASE_PATH=${{ github.event.release.url }}
    #       previous_release_created_at=$(curl -s -H "$AUTHORIZE" "$URL/releases" | jq -r '.[] | "\(.tag_name)\t\(.created_at)"' | sort -k2,2r | awk 'NR==2 {print $2}')
    #       echo "previous_release_created_at - $previous_release_created_at"
    #       issues=$(curl -s -H "$AUTHORIZE" "$URL/issues?state=closed&per_page=100&since=$previous_release_created_at&until=$(date -u +'%Y-%m-%dT%H:%M:%SZ')")
    #       echo "issues - $issues"
    #       issue_list=$(echo "$issues" | jq -r '.[] | "- \(.title) in [#\(.number)](\(.html_url)) by [@\(.assignee.login)](https://github.com/\(.assignee.login))"' | paste -sd '\n' -)
    #       echo "issue_list - $issue_list"
    #       curl -X PATCH -H "$AUTHORIZE" -d "{\"body\": \"Whats Changed:\\n\\n$issue_list\"}" "$CURRENT_RELEASE_PATH"
