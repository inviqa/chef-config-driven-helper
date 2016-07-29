group_domains = {}
%w{ apache nginx }.each do |server|
  next unless node[server] && node[server]['sites']

  node[server]['sites'].each do |name, site|
    group_name = site['ssl']['certfile']
    group_domains[group_name] ||= {domains: []}
    group_domains[group_name][:domains] << site['server_name']
    group_domains[group_name][:domains] += site['server_aliases'] if site['server_aliases']
    group_domains[group_name][:ssl] = site['ssl']
  end
end

group_domains.each do |group_name, certificate_data|
  subject_name = certificate_data[:ssl]['subject_name']
  subject_name_hash = {
    "C" => subject_name['country'],
    "S" => subject_name['state'],
    "L" => subject_name['location'],
    "O" => subject_name['organisation'],
    "OU" => subject_name['organisational_unit'],
    "CN" => certificate_data[:domains].first,
  }.select {|k,v| v && !v.empty?}
  directory File.dirname(certificate_data[:ssl]['keyfile'])
  directory File.dirname(certificate_data[:ssl]['certfile'])

  execute "Create SSL Certificate for #{group_name}" do
    command "openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 " +
             "-keyout #{certificate_data[:ssl]['keyfile']} " +
             "-out #{certificate_data[:ssl]['certfile']} " +
             "-subj \"/#{subject_name_hash.map{|k,v| "#{k}=#{v}"}.join('/')}\""
    not_if {
      File.exists?(certificate_data[:ssl]['certfile']) &&
      !File.zero?(certificate_data[:ssl]['certfile'])
    }
    umask 0077
  end

  file certificate_data[:ssl]['keyfile'] do
    owner "root"
  end

  file certificate_data[:ssl]['certfile'] do
    mode 0644
    owner "root"
  end
end
