include_recipe 'config-driven-helper::nginx-compat-disable-default'
include_recipe 'config-driven-helper::nginx-compat-https-map-emulation'

node["nginx"]["sites"].each do |name, site_attrs|
  definition = app_vhost name do
    site site_attrs
    server_type 'nginx'
  end
  ::Chef::Mixin::DeepMerge.hash_only_merge!(node.force_override['nginx']['sites'][name], definition.params[:site])
end
