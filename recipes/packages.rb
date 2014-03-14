if node['packages']
  node['packages'].each do |name|
    package name do
      action :install
    end
  end
end