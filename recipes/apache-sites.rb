if node["apache"] && node["apache"]["sites"]
  node["apache"]["sites"].each do |name, site|
    site = node["apache-sites"].merge(site)

    [site['protocols']].flatten.each do |current_protocol|
      next unless ['http', 'https'].include? current_protocol

      app_name = current_protocol == 'https' ? "#{name}.ssl" : name

      web_app app_name do
        site.each do |key, value|
          self.send key.gsub(" ", "_"), value
        end

        server_name name
        application_name site["application_name"] || app_name
        protocol current_protocol
      end
    end

    if site['protocols'].include? 'https'
      [
        site['ssl']['certfile'],
        site['ssl']['keyfile'],
        site['ssl']['cacertfile'],
        site['ssl']['certchainfile']
      ].each do |f|
        next if f.nil?
        file f do
          owner 'root'
          group 'root'
          mode 0644
          content node['ssl_certs'][f]
          notifies :reload, 'service[apache2]', :delayed
        end unless !node['ssl_certs'][f]
      end
    end
  end
end
