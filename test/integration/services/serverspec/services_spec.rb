require 'serverspec'
set :backend, :exec
set :path, '/sbin:/usr/local/sbin:$PATH'

describe "Services" do
  describe service("nginx") do
    it { should_not be_enabled }
    it { should_not be_running }
  end

  describe service("mysqld") do
    it { should_not be_enabled }
    it { should be_running }
  end
end
