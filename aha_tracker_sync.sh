#! /bin/sh

display_usage() { 
  printf "\nUsage:\naha_atracker_sync.sh [arguments] \n"
  exit 0
}

if [ -z "$TRACKER_TOKEN" ] || [ -z "$AHA_TOKEN" ] || [ -z "$TRACKER_PROJECT_ID" ] || [ -z "$AHA_PRODUCT_ID" ]; then
  display_usage
fi

existing_aha_releases=$(curl -s -H "Authorization: Bearer $AHA_TOKEN" "https://autonomic2.aha.io/api/v1/products/$AHA_PRODUCT_ID/releases")
releases=$(curl -s -X GET -H "X-TrackerToken: $TRACKER_TOKEN" "https://www.pivotaltracker.com/services/v5/projects/2167812/stories?with_story_type=release&with_state=planned&fields=name" | jq -r ".[].name")
IFS="$(printf '%b_' '\n')"; IFS="${IFS%_}"
for release in $releases; do
  jq_query_results=$(echo "$existing_aha_releases" | jq ".releases[] | select(.name == \"$release\")")
  if [ -z "$jq_query_results" ]; then
    echo "Creating release '$release'"
    curl -XPOST -H "Authorization: Bearer $AHA_TOKEN" -H "Content-Type: application/json" -H "Accept: application/json" -d "{\"release\":{\"name\":\"$release\"}}" "https://autonomic2.aha.io/api/v1/products/$AHA_PRODUCT_ID/releases"
  else
    echo "Release '$release' already exists in Aha"
    continue
  fi
done