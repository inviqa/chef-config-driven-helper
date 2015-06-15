node["apache"]["sites"].each do |name, site_attrs|
  definition = app_vhost name do
    site site_attrs
    server_type 'apache'
  end

  # Different versions of Chef return definitions differently
  if definition.is_a? Chef::Recipe
    site = definition.params[:site]
  else
    site = definition
  end
  ::Chef::Mixin::DeepMerge.hash_only_merge!(node.force_override['apache']['sites'][name], site)
end
