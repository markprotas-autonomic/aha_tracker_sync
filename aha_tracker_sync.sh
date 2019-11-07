#! /bin/sh

display_usage() { 
	echo -e "\nUsage:\naha_atracker_sync.sh [arguments] \n" 
}

if [ -z "$TRACKER_TOKEN" ] || [ -z "$AHA_TOKEN" ] || [ -z "$TRACKER_PROJECT_ID" ] || [ -z "$AHA_PRODUCT_ID" ]; then
  display_usage
fi

existing_aha_releases=`curl -s -H "Authorization: Bearer $AHA_TOKEN" https://autonomic2.aha.io/api/v1/products/$AHA_PRODUCT_ID/releases`
releases=`curl -s -X GET -H "X-TrackerToken: $TRACKER_TOKEN" "https://www.pivotaltracker.com/services/v5/projects/2167812/stories?with_story_type=release&with_state=planned&fields=name" | jq -r ".[].name"`
IFS=$'\n'
for release in $releases; do
  release_name_query_results=`echo $existing_aha_releases | jq -e ".releases[] | select(.name == \"$release\")"`
  if [[ $? == 0 ]]; then
    echo "Release '$release' already exists in Aha"
    continue
  else
    echo "Creating release '$release' already exists in Aha"
    curl -XPOST -H "Authorization: Bearer $AHA_TOKEN" -H "Content-Type: application/json" -H "Accept: application/json" -d "{\"release\":{\"name\":\"$release\"}}" https://autonomic2.aha.io/api/v1/products/$AHA_PRODUCT_ID/releases
  fi
done