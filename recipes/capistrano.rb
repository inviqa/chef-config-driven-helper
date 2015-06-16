%w( apache nginx ).each do |type|
  node[type]['sites'].each do |name, site|
    next unless site['capistrano']

    capistrano_app site['capistrano']['deploy_to'] do
      owner site['capistrano']['owner']
      group site['capistrano']['group']
      mode site['capistrano']['mode']
      shared_folders site['capistrano']['shared_folders']
    end
  end
end

users_manage node['capistrano']['group'] do
  group_id node['capistrano']['gid'] if node['capistrano']['gid']
  data_bag node['capistrano']['user_data_bag']
end

node['capistrano']['known_hosts'].each do |host, host_key|
  ssh_known_hosts_entry host do
    key host_key if host_key
  end
end