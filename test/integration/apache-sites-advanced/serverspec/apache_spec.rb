require 'serverspec'
require 'net/http'

set :backend, :exec

describe package('httpd'), :if => os[:family] == 'redhat' do
  it { should be_installed }
end

describe package('apache2'), :if => os[:family] == 'ubuntu' do
  it { should be_installed }
end

describe service('httpd'), :if => os[:family] == 'redhat' do
  it { should be_enabled }
  it { should be_running }
end

describe service('apache2'), :if => os[:family] == 'ubuntu' do
  it { should be_enabled }
  it { should be_running }
end

describe service('org.apache.httpd'), :if => os[:family] == 'darwin' do
  it { should be_enabled }
  it { should be_running }
end

describe port(80) do
  it { should be_listening }
end

describe command('curl localhost') do
  its(:stdout) { should eq "hello world" }
  its(:exit_status) { should eq 0 }
end

describe command('curl localhost/media/test.php') do
  its(:stdout) { should eq "<?php echo 'hello world';" }
  its(:exit_status) { should eq 0 }
end

describe command('curl localhost/secret/test.php') do
  its(:stdout) { should match /403 Forbidden/ }
end

describe command("curl -H 'Proxy: localhost' localhost/proxy-header-hide.php") do
  its(:stdout) { should eq "" }
  its(:exit_status) { should eq 0 }
end
