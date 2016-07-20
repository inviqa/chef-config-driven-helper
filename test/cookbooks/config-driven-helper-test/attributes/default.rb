default['nginx']['https_variable_emulation'] = platform_family?('rhel') && node['platform_version'].to_i < 7
