require 'serverspec'
require 'net/http'
require 'openssl'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.path = '/sbin:/usr/sbin'
  end
end

describe "SSL nginx-site configuration" do
  it "should not be listening on insecure port" do
    expect(port(80)).not_to be_listening
  end

  it "should be listening on secure port" do
    expect(port(443)).to be_listening
  end

  it "should respond with 200 on secure port" do
    uri = URI.parse('https://localhost:443')
    headers = { 'Host' => 'test.dev' }
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http = Net::HTTP.new(uri.host, uri.port)
    path = uri.path.empty? ? "/" : uri.path

    http.get(path, headers).code.should eq "200"
  end

  describe "site configuration file" do
    config_file = file("/etc/nginx/sites-enabled/test.dev")

    it "should use secure SSL protocols" do
      expect(config_file).to contain /ssl_protocols (TLSv1|TLSv1\.1|TLSv1\.2)+;/
    end

    it "should set ssl cert file" do
      expect(config_file).to contain /ssl_certificate \/etc\/ssl\/cert.pem;/
    end

    it "should set ssl cert key file" do
      expect(config_file).to contain /ssl_certificate_key \/etc\/ssl\/key.pem;/
    end

    it "should ensure prefer server ciphers set" do
      expect(config_file).to contain /ssl_prefer_server_cipers on;/
    end
  end

  describe file("/etc/ssl/cert.pem") do
    it { should be_file }
  end

  describe file("/etc/ssl/key.pem") do
    it { should be_file }
  end
end
