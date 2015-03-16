describe 'config-driven-helper::iptables-standard' do
  context 'sets up default ports' do
    let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

    %w(
      http
      https
      ssh
    ).each do |rule|
      it "creates a rule for #{rule}" do
        expect(chef_run).to create_iptables_ng_rule("20-#{rule}").with(
          chain: 'STANDARD-FIREWALL',
          rule: "--protocol tcp --dport #{rule} --jump ACCEPT"
        )
      end
    end
  end

  context 'sets up custom numeric ports' do
    rules = {
      'http' => 8080,
      'https' => 8443,
      'ssh' => 'ssh'
    }

    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['iptables-standard']['allowed_incoming_ports'] = rules
      end.converge(described_recipe)
    end

    rules.each do |rule, port|
      it "creates iptables_ng_rule[20-#{rule}]" do
        expect(chef_run).to create_iptables_ng_rule("20-#{rule}").with(
          chain: 'STANDARD-FIREWALL',
          rule: "--protocol tcp --dport #{port} --jump ACCEPT"
        )
      end
    end
  end
end