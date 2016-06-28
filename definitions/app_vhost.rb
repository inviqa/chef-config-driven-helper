define :app_vhost, :server_type => nil, :site => {} do

  type = params[:server_type] || site['server_type']

  Chef::Application.fatal!("Unsupported vhost type (#{type})") unless ['nginx', 'apache'].include? type

  site = ConfigDrivenHelper::Util::immutablemash_to_hash(params[:site])

  if site['inherits']
    site = ::Chef::Mixin::DeepMerge.hash_only_merge(
      ConfigDrivenHelper::Util::immutablemash_to_hash(node[type]['shared_config'][site['inherits']]),
      site)
  end

  site = ::Chef::Mixin::DeepMerge.hash_only_merge(ConfigDrivenHelper::Util::immutablemash_to_hash(node["#{type}-sites"]), site)
  site['server_name'] ||= params[:name]

  # BC attribute porting
  site['http_auth']['type'] = 'basic' if site['basic_username']

  [(site['protocols'] || ['http'])].flatten.each do |protocol|

    Chef::Application.fatal!("Unsupported vhost protocol (#{protocol}) for #{params[:name]}") unless ['http', 'https'].include? protocol

    service_name = type == 'nginx' ? type : 'apache2'
    name = protocol == 'https' ? "#{params[:name]}.ssl" : params[:name]
    template_name = name
    template_name = "#{template_name}.conf" if type == 'apache' && node[type]['version'] == '2.4'

    template "#{node[type]['dir']}/sites-available/#{template_name}" do
      source site["template"]
      cookbook site["cookbook"]

      variables({
        :params => site,
        :protocol => protocol,
        :type => node[type]
      })
      notifies :reload, "service[#{service_name}]", :delayed
    end

    [ site['ssl']['certfile'], site['ssl']['keyfile'] ].each do |f|
      next if f.nil?

      Chef::Application.fatal!("node['ssl_certs']['#{f}'] is not set but is used by the #{name} #{type} vhost") unless node['ssl_certs'][f]

      file f do
        owner 'root'
        group 'root'
        mode (f == site['ssl']['keyfile'] ? 0600 : 0644)
        content node['ssl_certs'][f]
        notifies :reload, "service[#{service_name}]", :delayed
      end
    end if protocol == 'https'

    self.send "#{type}_site", name do
      enable (defined? site['enable'] ? site['enable'] : true)
    end
  end

  params[:site] = site

  site
end
