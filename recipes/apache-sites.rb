if node["apache"] && node["apache"]["sites"]
  node["apache"]["sites"].each do |name, site|
    site = node["apache-sites"].merge(site)

    [site['protocol']].flatten.each do |current_protocol|
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
  end
end
