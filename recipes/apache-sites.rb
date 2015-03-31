node["apache"]["sites"].each do |name, site_attrs|
  site = app_vhost name do
    site site_attrs
    server_type 'apache'
  end
  ::Chef::Mixin::DeepMerge.hash_only_merge!(node.force_override['apache']['sites'][name], site)
end
