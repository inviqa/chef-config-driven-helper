if node["nginx"] && node["nginx"]["sites"]
  node["nginx"]["sites"].each do |name, site|
    site = node["nginx-sites"]
      .merge(site)

    site['server_name'] = name if !site['server_name']
    name = site['server_name']

    template "/etc/nginx/sites-available/#{name}" do
      source site["template"]
      cookbook site["cookbook"]

      variables({
        :params => site
      })
      notifies :reload, 'service[nginx]', :delayed
    end

    if site['protocols'].include? 'https'
      [ site['ssl']['certfile'], site['ssl']['keyfile'] ].each do |f|
        next if f.nil?
        file f do
          owner 'root'
          group 'root'
          mode 0644
          content node['ssl_certs'][f]
          notifies :reload, 'service[nginx]', :delayed
        end unless !node['ssl_certs'][f]
      end
    end

    nginx_site name
  end

  # Default nginx site on CentOS defined here
  # And it's hardcoded to listen on port 80
  # Problematic if using varnish
  file "/etc/nginx/conf.d/default.conf" do
    content ""
  end unless node["nginx"]["default_site_enabled"]

  service "nginx" do
    action :reload
  end
end
