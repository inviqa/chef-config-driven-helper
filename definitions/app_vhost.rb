define :app_vhost, :server_type => nil, :site => {} do

  site = params[:site]
  type = params[:server_type] || site['server_type']

  Chef::Log.fatal!("Unsupported vhost type (#{type})") unless ['nginx', 'apache'].include? type

  [(site['protocols'] || ['http'])].flatten.each do |protocol|

    Chef::Log.fatal!("Unsupported vhost protocol (#{protocol}) for #{params[:name]}") unless ['http', 'https'].include? protocol

    service_name = type == 'nginx' ? type : 'apache2'
    name = protocol == 'https' ? "#{params[:name]}.ssl" : params[:name]

    template "#{node[type]['dir']}/sites-available/#{name}" do
      source site["template"]
      cookbook site["cookbook"]

      variables({
        :params => site,
        :protocol => protocol
      })
      notifies :reload, "service[#{service_name}]", :delayed
    end

    [ site['ssl']['certfile'], site['ssl']['keyfile'] ].each do |f|
      next if f.nil?

      Chef::Log.fatal!("node['ssl_certs']['#{f}'] is not set but is used by the #{name} #{type} vhost") unless node['ssl_certs'][f]

      file f do
        owner 'root'
        group 'root'
        mode 0644
        content node['ssl_certs'][f]
        notifies :reload, "service[#{service_name}]", :delayed
      end
    end if protocol == 'https'

    self.send "#{type}_site", name do
      enable (defined? site['enable'] ? site['enable'] : true)
    end
  end
end
