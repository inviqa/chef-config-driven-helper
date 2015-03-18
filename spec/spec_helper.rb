require 'chefspec'
require 'chefspec/berkshelf'

module Kitchen
  module Provisioner
    class ChefBase
      private

      def berksfile
        File.join(config[:kitchen_root], "test/Berksfile")
      end
    end
  end
end
