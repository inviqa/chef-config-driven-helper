require 'serverspec'
require 'net/http'

set :backend, :exec
set :path, '/sbin:/usr/local/sbin:$PATH'

RSpec.configure do |c|
  c.before :all do
    c.path = '/sbin:/usr/sbin'
  end
end

describe "Capistrano configuration" do
  it "should create a capistrano application folder structure" do
    expect(file('/var/www/test.dev')).to be_owned_by 'root'
    expect(file('/var/www/test.dev')).to be_grouped_into 'nobody'
    expect(file('/var/www/test.dev')).to be_directory

    expect(file('/var/www/test.dev/shared')).to be_grouped_into 'nobody'
    expect(file('/var/www/test.dev/shared')).to be_directory
    expect(file('/var/www/test.dev/releases')).to be_directory
  end

  it "should create a readable shared folder structure" do
    expect(file('/var/www/test.dev/shared/readable1')).to be_directory
    expect(file('/var/www/test.dev/shared/readable1')).to be_owned_by 'root'
    expect(file('/var/www/test.dev/shared/readable1')).to be_grouped_into 'nobody'

    expect(file('/var/www/test.dev/shared/readable2')).to be_directory
    expect(file('/var/www/test.dev/shared/readable2')).to be_owned_by 'root'
    expect(file('/var/www/test.dev/shared/readable2')).to be_grouped_into 'nobody'
  end

  it "should create a writeable shared folder structure" do
    expect(file('/var/www/test.dev/shared/writeable1')).to be_directory
    expect(file('/var/www/test.dev/shared/writeable1')).to be_owned_by 'nobody'
    expect(file('/var/www/test.dev/shared/writeable1')).to be_grouped_into 'nobody'

    expect(file('/var/www/test.dev/shared/readable2/writeable2')).to be_directory
    expect(file('/var/www/test.dev/shared/readable2/writeable2')).to be_owned_by 'nobody'
    expect(file('/var/www/test.dev/shared/readable2/writeable2')).to be_grouped_into 'nobody'
  end

end
