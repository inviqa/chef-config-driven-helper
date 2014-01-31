if node["apache"] && node["apache"]["sites"]
  node["apache"]["sites"].each do |name, site|
    web_app name do
      server_name name
      server_aliases site["aliases"] || []
      docroot site["docroot"]
      application_name site["application_name"] || name

      if !site["template_cookbook"]
        cookbook "apache2"
      end

      if site["template"]
        template site["template"]
      end

      site.each do |key, value|
        next if ["aliases", "docroot", "template_cookbook", "template"].include? key.to_s
        self.send key.gsub(" ", "_"), value
      end
    end
  end
end