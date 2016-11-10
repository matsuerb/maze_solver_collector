#!/bin/bash
bundle install
rails db:migrate
rails assets:precompile
touch tmp/restart.txt

