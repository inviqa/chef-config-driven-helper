Vagrant.configure('2') do |config|
  if Vagrant.has_plugin?("vagrant-berkshelf") then
    config.berkshelf.enabled = false
  end
end
