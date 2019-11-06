#! /bin/sh

display_usage() { 
  echo "Install jq via homebrew: brew installl jq"
  echo -e "Obtain API tokens for both Pivotal Tracker and Aha via https://www.pivotaltracker.com/profile and https://autonomic2.aha.io/settings/api_keys, respectively.\nSet those keys as the environment variables TRACKER_TOKEN and AHA_TOKEN"
  echo -e "Set the TRACKER_PROJECT_ID environment variable to the id of your Tracker project"
  echo -e "Set the AHA_PRODUCT_ID environment variable to the id of your Aha project"
	echo -e "\nUsage:\naha_atracker_sync.sh [arguments] \n" 
}

if [ -z "$TRACKER_TOKEN" ] || [ -z "$AHA_TOKEN" ] || [ -z "$TRACKER_PROJECT_ID" ] || [ -z "$AHA_PRODUCT_ID" ]; then
  display_usage
fi

releases=`curl -X GET -H "X-TrackerToken: $TRACKER_TOKEN" "https://www.pivotaltracker.com/services/v5/projects/2167812/stories?with_story_type=release&with_state=planned" | jq . | grep name | awk '{ s = ""; for (i = 2; i <= NF; i++) s = s $i " "; print s }'`
IFS=','
for release in $releases; do
  curl -XPOST -H "Authorization: Bearer $AHA_TOKEN" -H "Content-Type: application/json" -H "Accept: application/json" -d "{\"release\":{\"name\":${release}}}" https://autonomic2.aha.io/api/v1/products/$AHA_PRODUCT_ID/releases
done