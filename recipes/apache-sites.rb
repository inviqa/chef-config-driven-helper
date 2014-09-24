node["apache"]["sites"].each do |name, site_attrs|
  app_vhost name do
    site site_attrs
    server_type 'apache'
  end
end
