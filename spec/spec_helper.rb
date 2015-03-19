require 'chefspec'
require 'chefspec/berkshelf'

module ChefSpec
  class Berkshelf
  	alias_method :old_setup!, :setup!
    def setup!
      Dir.chdir File.expand_path("../../test", __FILE__) do
      	old_setup!
      end
  	end
  end
end
