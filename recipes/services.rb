if node['services']
  node['services'].each do |k, v|
    service k do
      action [v].flatten.map(&:to_sym)
    end
  end
end