conf_dir = node['apache']['conf_dir'] || "#{node['apache']['dir']}/conf"

file "#{conf_dir}/test.conf" do
  content "# Test include file"
end
