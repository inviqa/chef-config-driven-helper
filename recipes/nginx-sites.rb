include_recipe 'config-driven-helper::nginx-compat-disable-default'
include_recipe 'config-driven-helper::nginx-compat-https-map-emulation'

node["nginx"]["sites"].each do |name, site_attrs|
  definition = app_vhost name do
    site site_attrs
    server_type 'nginx'
  end

  # Different versions of Chef return definitions differently
  if definition.is_a? Chef::Recipe
    site = definition.params[:site]
  else
    site = definition
  end

  values = node.attribute.combined_override['nginx']['sites'][name]
  ::Chef::Mixin::DeepMerge.hash_only_merge!(values, site)
  node.force_override!['nginx']['sites'][name] = values

end
