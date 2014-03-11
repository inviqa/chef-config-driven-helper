if node["mysql"] && node["mysql"]["users"]
  node["mysql"]["users"].each do |name, details|
    mysql_database_user name do
      details.each do |key, value|
        self.send key, value
      end
    end
  end
end