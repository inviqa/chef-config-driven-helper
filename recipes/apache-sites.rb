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

  values = node.attribute.combined_override['apache']['sites'][name]
  ::Chef::Mixin::DeepMerge.hash_only_merge!(values, site)
  node.force_override!['apache']['sites'][name] = values

end
