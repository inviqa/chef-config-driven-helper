describe 'config-driven-helper::nginx-sites' do
  let(:http_vhost) { '/etc/nginx/sites-available/example.com' }
  let(:https_vhost) { '/etc/nginx/sites-available/example.com.ssl' }

  context 'with proxy config' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['ssl_certs']['t.cert'] = 'an example cert'
        node.set['ssl_certs']['t.key'] = 'an example key'
        node.set['nginx']['sites']['example.com']['ssl']['certfile'] = 't.cert'
        node.set['nginx']['sites']['example.com']['ssl']['keyfile'] = 't.key'
        node.set['nginx']['sites']['example.com']['server_name'] = 'example.com'
        node.set['nginx']['sites']['example.com']['protocols'] = %w(http https)
        node.set['nginx']['sites']['example.com']['locations']['/'] = {
          'type' => 'path_not_regex',
          'mode' => 'proxy',
          'proxy' => {
            'location' => 'http://127.0.0.1:8080',
            'proxy_connect_timeout' => '30',
            'proxy_send_timeout' => '40',
            'proxy_read_timeout' => '50',
            'send_timeout' => '70'
          }
        }
      end.converge('recipe[nginx]', described_recipe)
    end

    it 'will write a proxy configuration' do
      [http_vhost, https_vhost].each do |vhost|
        expect(chef_run).to render_file(vhost).with_content(
          %r{location / \{[^\}]*proxy_pass http://127.0.0.1:8080;}m
        )
      end
    end

    it 'will write a https forwarded proto header for the ssl vhost' do
      expect(chef_run).to render_file(https_vhost).with_content(
        %r{location / \{[^\}]*proxy_set_header X-Forwarded-Proto https;}m
      )
    end

    it 'will not write a https forwarded proto header for the http vhost' do
      expect(chef_run).to_not render_file(http_vhost).with_content(
        %r{location / \{[^\}]*proxy_set_header X-Forwarded-Proto https;}m
      )
    end

    it 'will write a proxy_connect_timeout configuration' do
      [http_vhost, https_vhost].each do |vhost|
        expect(chef_run).to render_file(vhost).with_content(
          %r{location / \{[^\}]*proxy_connect_timeout 30;}m
        )
      end
    end

    it 'will write a proxy_send_timeout configuration' do
      [http_vhost, https_vhost].each do |vhost|
        expect(chef_run).to render_file(vhost).with_content(
          %r{location / \{[^\}]*proxy_send_timeout 40;}m
        )
      end
    end

    it 'will write a proxy_read_timeout configuration' do
      [http_vhost, https_vhost].each do |vhost|
        expect(chef_run).to render_file(vhost).with_content(
          %r{location / \{[^\}]*proxy_read_timeout 50;}m
        )
      end
    end

    it 'will write a send_timeout configuration' do
      [http_vhost, https_vhost].each do |vhost|
        expect(chef_run).to render_file(vhost).with_content(
          %r{location / \{[^\}]*send_timeout 70;}m
        )
      end
    end
  end
end
