node["apache"]["sites"].each do |name, site_attrs|
  [site_attrs['protocols']].flatten.each do |current_protocol|

    next unless ['http', 'https'].include? current_protocol
    app_name = current_protocol == 'https' ? "#{name}.ssl" : name

    app_vhost app_name do
      site site_attrs
      protocol current_protocol
      type 'apache'
    end

  end
end
