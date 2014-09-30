include_recipe 'config-driven-helper::nginx-compat-disable-default'
include_recipe 'config-driven-helper::nginx-compat-https-map-emulation'

node["nginx"]["sites"].each do |name, site_attrs|
  app_vhost name do
    site site_attrs
    server_type 'nginx'
  end
end
