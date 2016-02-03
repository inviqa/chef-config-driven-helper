source 'https://supermarket.chef.io'

metadata

cookbook 'nginx', '> 2.0', '< 2.4.4'

if defined?(Kitchen::Provisioner::Chef::Berkshelf)
  instance_eval(File.read(File.join(File.dirname(__FILE__), 'test/Berksfile')))
end
