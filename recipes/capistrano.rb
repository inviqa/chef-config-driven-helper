%w( apache nginx ).each do |type|
  node[type]['sites'].each do |name, site|
    next unless site['capistrano']

    capistrano_app site['capistrano']['deploy_to'] do
      owner site['capistrano']['owner']
      group site['capistrano']['group']
      shared_folders site['capistrano']['shared_folders']
    end
  end
end