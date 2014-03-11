if node["mysql"] && node["mysql"]["databases"]
  node["mysql"]["databases"].each do |name, details|
    mysql_database name do
      details["connection"] = "default" unless details["connection"]

      if details["connection"] && details["connection"].is_a? String
        connection node["mysql"]["connections"][details["connection"]]
      end

      details.delete "connection"

      details.each do |key, value|
        self.send key, value
      end
    end
  end
end