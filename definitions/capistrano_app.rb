define :capistrano_app, :deploy_to => nil do
  params[:deploy_to] ||= params[:name]

  if params[:owner].nil? || params[:group].nil?
    Chef::Log.fatal("capistrano_app[#{params[:name]}] did not supply either an owner or group")
    raise
  end

  directory params[:deploy_to] do
    owner params[:owner]
    group params[:group]
  end

  %w( shared releases ).each do |folder|
    directory "#{params[:deploy_to]}/#{folder}" do
      owner params[:owner]
      group params[:group]
    end
  end

  params[:shared_folders].each do |_, type|
    type['folders'].each do |folder|
      begin
        directory "#{params[:deploy_to]}/shared/#{folder}" do
          owner type['owner'] || params[:owner]
          group type['group'] || params[:group]
          recursive true
        end
        folder = File.dirname(folder)
      end until folder == '.' || File.basename(folder) == '.'
    end
  end if params[:shared_folders]
end