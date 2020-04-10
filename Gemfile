source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

gem 'bootsnap', require: false
gem 'high_voltage'
gem 'pg'
gem 'puma'
gem 'rails', '~> 6.0.0', github: 'rails/rails', branch: '6-0-stable'
gem 'sassc-rails'
gem 'simple_form'
gem 'turbolinks'
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'webpacker'

group :development do
  gem 'listen'
  gem 'rack-mini-profiler', require: false
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'web-console'
end

group :development, :test do
  gem 'awesome_print'
  gem 'bullet'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'factory_bot_rails'
  gem 'rspec-rails'
end

group :test do
  gem 'capybara'
  gem 'formulaic'
  gem 'shoulda-matchers'
  gem 'capybara'
end
