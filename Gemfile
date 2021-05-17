source "https://rubygems.org"

gem 'rake', '~> 12.3'
gem 'berkshelf', '~> 4.0'

group :integration do
  gem 'kitchen-vagrant', '~> 0.20.0'
  gem 'test-kitchen', '~> 1.7'
end

group :test do
  gem 'chefspec', '~> 4.4'
  gem 'foodcritic', '~> 6.0'
  gem 'nokogiri', '~> 1.11.4'
  gem 'rubocop', '~> 0.48.1'
end

group :deployment do
  gem 'stove', '~> 3.2'
end
