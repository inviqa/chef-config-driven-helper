include_recipe 'mysql::client'
include_recipe 'build-essential'

gem_package "mysql" do
  gem_binary nil
  action :install
end
