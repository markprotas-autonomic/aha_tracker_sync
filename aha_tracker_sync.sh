#! /bin/sh

display_usage() { 
  echo -e "Obtain API tokens for both Pivotal Tracker and Aha via https://www.pivotaltracker.com/profile and https://autonomic2.aha.io/settings/api_keys, respectively.\nSet those keys as the environment variables TRACKER_TOKEN and AHA_TOKEN"
	echo -e "\nUsage:\naha_atracker_sync.sh [arguments] \n" 
}

if [ -z "$TRACKER_TOKEN" ] || [ -z "$AHA_TOKEN" ]; then
  display_usage
fi
