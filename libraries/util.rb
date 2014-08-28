module ConfigDrivenHelper
  module Util
    def immutablemash_to_hash(immutable_mash)
      result = immutable_mash.to_hash.dup
      result.each_pair do |key, value|
        if value.is_a?(Chef::Node::ImmutableMash)
          result[key] = immutablemash_to_hash(value)
        end
      end
    end
  end
end