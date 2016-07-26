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
    if type == 'apache'
      apache2_cookbook_version = run_context.cookbook_collection['apache2'].metadata.version
      template_name = "#{template_name}.conf" if Gem::Dependency.new('', '>= 2').match?('', apache2_cookbook_version)
    end

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

      ruby_block 'raise if issue with #{f}' do
        block do
          unless File.exist?(f) || node['ssl_certs'][f]
            raise "#{f} not present for #{name} #{type} vhost but node['ssl_certs']['#{f}'] is not defined"
          end
        end
        action :run
      end

      file f do
        owner 'root'
        group 'root'
        mode (f == site['ssl']['keyfile'] ? 0600 : 0644)
        content node['ssl_certs'][f]
        notifies :reload, "service[#{service_name}]", :delayed
      end if node['ssl_certs'][f]
    end if protocol == 'https'

    self.send "#{type}_site", name do
      enable (defined? site['enable'] ? site['enable'] : true)
    end
  end

  params[:site] = site

  site
end
