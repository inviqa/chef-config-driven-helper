require 'serverspec'
require 'net/http'

set :backend, :exec
set :path, '/sbin:/usr/local/sbin:$PATH'

RSpec.configure do |c|
  c.before :all do
    c.path = '/sbin:/usr/sbin'
  end
end

describe "Minimal nginx-site configuration" do
  it "should be listening on insecure port" do
    expect(port(80)).to be_listening
  end

  it "should not be listening on secure port" do
    expect(port(443)).not_to be_listening
  end

  it "should respond with 200 on insecure port" do
    uri = URI.parse('http://localhost:80')
    headers = { 'Host' => 'test.dev' }
    http = Net::HTTP.new(uri.host, uri.port)
    path = uri.path.empty? ? "/" : uri.path

    http.get(path, headers).code.should eq "200"
  end

  describe "site configuration file" do
    config_file = file("/etc/nginx/sites-enabled/site1")

    its "docroot should be /docroot" do
       expect(config_file).to contain /root \/docroot/
    end

    it "should use php-fpm socket" do
      expect(config_file).to contain /fastcgi_pass unix:\/var\/run\/php-fpm-www\.sock/
    end
  end
end
