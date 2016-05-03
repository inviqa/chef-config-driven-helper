require 'kitchen/provisioner/chef_base'
require 'kitchen/provisioner/chef/common_sandbox'
require 'kitchen/provisioner/chef/berkshelf'

Kitchen::Provisioner::ChefBase.class_eval do
  default_config :berksfile, 'test/Berksfile'

  private

  def berksfile
    File.join(config[:kitchen_root], config[:berksfile])
  end
end

Kitchen::Provisioner::Chef::CommonSandbox.class_eval do
  private

  def berksfile
    File.join(config[:kitchen_root], config[:berksfile])
  end
end

Kitchen::Provisioner::Chef::Berkshelf.class_eval do
  alias :_resolve :resolve
  def resolve
    Dir.chdir(File.dirname(@berksfile)) do
      _resolve
    end
  end
end
