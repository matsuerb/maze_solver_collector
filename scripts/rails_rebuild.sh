#!/bin/bash
bundle install
rails db:migrate
rails maze:import
rails assets:precompile
bin/delayed_job restart
touch tmp/restart.txt

