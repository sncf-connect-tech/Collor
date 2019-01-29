#!/usr/bin/env bash

bundle install

bundle exec pod repo update --verbose
bundle exec pod install