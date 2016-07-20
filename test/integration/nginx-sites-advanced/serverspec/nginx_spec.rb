require 'serverspec'
require 'net/http'

set :backend, :exec

describe command('curl localhost') do
  its(:stdout) { should eq "hello world" }
  its(:exit_status) { should eq 0 }
end

describe command("curl -H 'Proxy: localhost' localhost/proxy-header-hide.php") do
  its(:stdout) { should eq "" }
  its(:exit_status) { should eq 0 }
end
