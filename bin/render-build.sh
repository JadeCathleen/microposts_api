#!/usr/bin/env bash
# Exit on error
set -o errexit

bundle install
# For a full Rails app, you'd add asset compilation here,
# but for an API-only app, you likely won't have assets.

# If you're using a Free instance type, you need to perform
# database migrations in the build command. Uncomment the
# following line:
echo "===> running migrations"
bundle exec rails db:migrate
