source "https://rubygems.org"

gem 'rake', '~> 10.1'
gem 'berkshelf', '~> 4.0'

group :integration do
  gem 'kitchen-vagrant', '~> 0.19.0'
  gem 'test-kitchen', '~> 1.4'
  gem 'kitchen-docker', '~> 2.3.0'
end

group :test do
  gem 'chefspec', '~> 4.4'
  gem 'foodcritic', '~> 5.0'
  gem 'nokogiri', '~> 1.6.3.1'
  gem 'rubocop', '~> 0.35.1'
end

group :deployment do
  gem 'stove', '~> 3.2'
end
