if node['services']
  node['services'].each do |k, v|
    service k do
      action :nothing
    end
    ruby_block "service control (#{k})" do
      block do
        r = resources(:service => k)
        v.flatten.map(&:to_sym).each do |a|
          r.run_action a
        end
      end
      subscribes :run, "service[#{k}]", :delayed
      action :nothing
    end
  end
end
