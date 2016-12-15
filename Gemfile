source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
gem 'less-rails'
gem 'twitter-bootstrap-rails'

gem 'jbuilder'

gem "font-awesome-rails"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
	gem 'pry-rails'
	gem "better_errors"
	gem 'binding_of_caller'
  gem "test-unit-rails"
  gem "factory_girl_rails"
  gem "ruby-progressbar"
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'validates_email_format_of'
gem "structured_logger"
gem 'config'
gem "delayed_job_active_record"
# delayed_job_active_record.gem needs daemons.gem.
# https://github.com/collectiveidea/delayed_job/tree/v4.1.2#user-content-running-jobs
gem "daemons"
# suppress DEPRECATION WARNING.
# https://github.com/collectiveidea/delayed_job/pull/948
gem "delayed_job", github: "atomaka/delayed_job", branch: "bugfix/rails5-reloader"
gem "bundler-audit"
gem "ruby_audit"
