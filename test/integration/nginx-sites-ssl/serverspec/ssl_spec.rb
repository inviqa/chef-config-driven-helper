require 'serverspec'
require 'net/http'
require 'openssl'

set :backend, :exec
set :path, '/sbin:/usr/local/sbin:$PATH'

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
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    path = uri.path.empty? ? "/" : uri.path

    expect(http.get(path, headers).code).to match "200"
  end


  describe "site configuration file" do
    config_file = file("/etc/nginx/sites-enabled/site1.ssl")

    it "should use secure SSL protocols" do
      expect(config_file).to contain "ssl_protocols TLSv1 TLSv1.1 TLSv1.2;"
    end

    it "should set ssl cert file" do
      expect(config_file).to contain Regexp.new("ssl_certificate.*/etc/pki/tls/certs/cert.pem;")
    end

    it "should set ssl cert key file" do
      expect(config_file).to contain Regexp.new("ssl_certificate_key.*/etc/pki/tls/private/key.pem;")
    end

    it "should ensure prefer server ciphers set" do
      expect(config_file).to contain Regexp.new("ssl_prefer_server_ciphers.*on;")
    end
  end


  describe file("/etc/pki/tls/certs/cert.pem") do
    it { should be_file }

    it { should be_mode 644 }
  end

  describe file("/etc/pki/tls/private/key.pem") do
    it { should be_file }

    it { should be_mode 600 }
  end
end