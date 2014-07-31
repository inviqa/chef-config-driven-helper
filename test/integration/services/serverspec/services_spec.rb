require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.path = '/sbin:/usr/sbin'
  end
end

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
