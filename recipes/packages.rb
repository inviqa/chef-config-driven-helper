if Gem::Dependency.new('chef', Chef::Version).match('chef', '>= 12.10')
  raise 'config-driven-helper::packages not supported in chef >= 12.10. Please use config-driven-helper::packages-additional instead, which uses a different syntax'
end

if node['packages-additional']
  node['packages-additional'].each do |name, data|
    data = { action: data } if data.is_a?(String)
    package name do
      data.each do |key,value|
        self.send key, value
      end
    end
  end
end
