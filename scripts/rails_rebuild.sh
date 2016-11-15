#!/bin/bash
bundle install
rails db:migrate
rails maze:import
rails assets:precompile
touch tmp/restart.txt

