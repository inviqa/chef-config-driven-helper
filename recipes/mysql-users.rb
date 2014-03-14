if node["mysql"] && node["mysql"]["users"]
  include_recipe "database::mysql"

  node["mysql"]["users"].each do |name, details|
    mysql_database_user name do
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
      action details["action"] || :grant

      details.each do |key, value|
        next if key.to_s == "connection"
        self.send key, value
      end
    end
  end
end
