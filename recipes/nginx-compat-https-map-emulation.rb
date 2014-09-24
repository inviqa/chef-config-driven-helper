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