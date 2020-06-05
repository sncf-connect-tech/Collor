#!/usr/bin/env bash

bundle install --path ./local/gems --binstubs ./local/bin

bundle exec pod install || if [[ $? != 0 ]]; then bundle exec pod install --repo-update; fi
