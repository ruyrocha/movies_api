#!/usr/bin/env bash

echo "Re-create databases and add seeds..."
bundle exec rails db:setup
echo "Removing stale PID file"
/bin/rm tmp/pids/server.pid
echo "Starting the Rails server..."
bundle exec rails server
