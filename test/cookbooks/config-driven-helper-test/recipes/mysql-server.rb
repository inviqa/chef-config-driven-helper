
case node['platform']
when 'amazon'
  el_version = 6
else
  el_version = node['platform_version'].to_i
end

if el_version >= 7
  node.set['mysql']['version'] = '5.6'
  node.set['mysql']['server']['packages'] = ['Percona-Server-server-56', 'Percona-Server-devel-56']
  node.set['mysql']['server']['slow_query_log']       = 1
  node.set['mysql']['server']['slow_query_log_file']  = '/var/log/mysql/slow.log'
  node.set['mysql']['server']['service_name'] = 'mysql'
  node.set['mysql']['client']['packages'] = ['Percona-Server-client-56', 'Percona-Server-devel-56']
  package 'mariadb-libs' do
    action :remove
  end
  include_recipe 'yum-percona'
end

include_recipe 'mysql::server'
