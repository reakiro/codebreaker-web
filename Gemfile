source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem 'codebreaker', git: 'https://github.com/reakiro/codebreaker-gem', branch: 'master'
gem 'rack'

group :develop do
  gem 'fasterer'
  gem 'pry'
  gem 'rubocop'
  gem 'rubocop-rspec'
end

group :test do
  gem 'rack-test'
  gem 'rspec'
  gem 'rspec_junit_formatter'
  gem 'simplecov'
end