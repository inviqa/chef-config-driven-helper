ChefSpec.define_matcher :users_manage

if defined?(ChefSpec)
  def create_users_manage(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:users_manage,
                                            :create,
                                            resource_name)
  end
end