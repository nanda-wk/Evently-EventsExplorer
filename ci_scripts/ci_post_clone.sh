#!/bin/sh

#  ci_post_clone.sh
#  Evently-EventsExplorer
#
#  Created by Nanda WK on 2025-09-04.
#

# This script uses the CI_WORKSPACE environment variable provided by Xcode Cloud
# to locate the project's root directory. This makes the path relative and
# ensures it works in the CI environment, not just on a local machine.

CONFIG_FILE_PATH="$CI_WORKSPACE/Evently-EventsExplorer/Resources/Env.xcconfig"

echo "Creating config file at: $CONFIG_FILE_PATH"

echo "API_BASE_URL = $API_BASE_URL" >> "$CONFIG_FILE_PATH"
echo "API_KEY = $API_KEY" >> "$CONFIG_FILE_PATH"

echo "Successfully created Env.xcconfig"