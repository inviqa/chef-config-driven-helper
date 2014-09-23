node["nginx"]["sites"].each do |name, site_attrs|
  [site_attrs['protocols']].flatten.each do |current_protocol|

    next unless ['http', 'https'].include? current_protocol
    app_name = current_protocol == 'https' ? "#{name}.ssl" : name

    app_vhost app_name do
      site site_attrs
      protocol current_protocol
      type 'nginx'
    end

  end
end


# Default nginx site on CentOS defined here
# And it's hardcoded to listen on port 80
# Problematic if using varnish
file "/etc/nginx/conf.d/default.conf" do
  content ""
  notifies :reload, "service[nginx]"
end unless node["nginx"]["default_site_enabled"]

https_map = <<-eos
  map $scheme $https {
      default "";
      https on;
  }
eos

file "#{node['nginx']['dir']}/conf.d/https.conf" do
  content https_map
  owner 'root'
  group node['root_group']
  mode '0644'
  notifies :reload, 'service[nginx]'
end if node['nginx']['https_variable_emulation']
