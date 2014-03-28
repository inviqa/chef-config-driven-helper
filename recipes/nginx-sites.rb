if node["nginx"] && node["nginx"]["sites"]
  node["nginx"]["sites"].each do |name, site|
    site = node["nginx-sites"]
      .merge(site)
      .merge({'server_name' => name})

    template "/etc/nginx/sites-available/#{name}" do
      source site["template"]
      cookbook site["cookbook"]

      variables({
        :params => site
      })

    end

    nginx_site name
  end

  # Default nginx site on CentOS defined here
  # And it's hardcoded to listen on port 80
  # Problematic if using varnish
  file "/etc/nginx/conf.d/default.conf" do
    action :delete
  end unless node["nginx"]["default_site_enabled"]

  service "nginx" do
    action :reload
  end
end