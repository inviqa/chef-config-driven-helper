define :app_vhost, :type => 'nginx', :site => {}, :protocol => nil do

  # TODO proper chef exception
  raise Exception.new "Unspported vhost type (#{params[:type]}" unless ['nginx', 'apache'].include? params[:type]

  site = params[:site]
  type = params[:type]
  service_name = type == 'nginx' ? type : 'apache2'

  name = params[:name]

  template "#{node[type]['dir']}/sites-available/#{name}" do
    source site["template"]
    cookbook site["cookbook"]

    variables({
      :params => site,
      :protocol => params[:protocol]
    })
    notifies :reload, "service[#{service_name}]", :delayed
  end

  if (params[:protocol].nil? and site['protocols'].include? 'https') or params[:protocol] == 'https'
    [ site['ssl']['certfile'], site['ssl']['keyfile'] ].each do |f|
      next if f.nil?
      file f do
        owner 'root'
        group 'root'
        mode 0644
        content node['ssl_certs'][f]
        notifies :reload, "service[#{service_name}]", :delayed
      end unless !node['ssl_certs'][f]
    end
  end

  self.send "#{type}_site", name do
    enable (defined? site['enable'] ? site['enable'] : true)
  end
end
