This script synchronizes planned releases from Pivotal Tracker to Aha.  In order to use it, you'll need to:

1. Install jq via homebrew: `brew install jq`
1. Obtain API keys from [Pivotal Tracker](https://www.pivotaltracker.com/profile) and [Aha](https://autonomic2.aha.io/settings/api_keys)
1. Set the following environment variables: `AHA_TOKEN`, `TRACKER_TOKEN`, `TRACKER_PROJECT_ID`, `AHA_PRODUCT_ID`