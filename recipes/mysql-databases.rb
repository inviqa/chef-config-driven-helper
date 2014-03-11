if node["mysql"] && node["mysql"]["databases"]
  include_recipe "database::mysql"

  node["mysql"]["databases"].each do |name, details|
    mysql_database name do
      connection_name = if !details["connection"]
        "default"
      elsif details["connection"].is_a?(String)
        details["connection"]
      end

      if connection_name
        connection_details = node["mysql"]["connections"][connection_name]
      else
        connection_details = details["connection"]
      end

      connection connection_details

      details.each do |key, value|
        next if key.to_s == "connection"
        self.send key, value
      end
    end
  end
end
