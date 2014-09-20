
node["nginx"]["sites"].each do |name, site_attrs|
  app_vhost name do
    site site_attrs
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
