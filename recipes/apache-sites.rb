if node["apache"] && node["apache"]["sites"]
  node["apache"]["sites"].each do |name, site|
    site = node["apache-sites"].merge(site)
    web_app name do
      server_name name
      application_name site["application_name"] || name

      site.each do |key, value|
        next if ["template_cookbook"].include? key.to_s
        self.send key.gsub(" ", "_"), value
      end
    end
  end
end