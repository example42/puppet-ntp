require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'ntp' do

  let(:title) { 'ntp' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) { { :ipaddress => '10.42.42.42' } }

  describe 'Test standard installation' do
    it { should contain_package('ntp').with_ensure('present') }
    it { should contain_service('ntp').with_ensure('running') }
    it { should contain_service('ntp').with_enable('true') }
    it { should contain_file('ntp.conf').with_ensure('present') }
    it 'should generate a valid default template' do
      content = catalogue.resource('file', 'ntp.conf').send(:parameters)[:content]
      content.should match "server pool.ntp.org"
    end
  end

  describe 'Test installation of a specific version' do
    let(:params) { {:version => '1.0.42' } }
    it { should contain_package('ntp').with_ensure('1.0.42') }
  end

  describe 'Test standard installation with monitoring and firewalling' do
    let(:params) { {:monitor => true , :firewall => true, :port => '42', :protocol => 'tcp' } }

    it { should contain_package('ntp').with_ensure('present') }
    it { should contain_service('ntp').with_ensure('running') }
    it { should contain_service('ntp').with_enable('true') }
    it { should contain_file('ntp.conf').with_ensure('present') }
    it 'should monitor the process' do
      content = catalogue.resource('monitor::process', 'ntp_process').send(:parameters)[:enable]
      content.should == true
    end
    it 'should place a firewall rule' do
      content = catalogue.resource('firewall', 'ntp_tcp_42').send(:parameters)[:enable]
      content.should == true
    end
  end

  describe 'Test decommissioning - absent' do
    let(:params) { {:absent => true, :monitor => true , :firewall => true, :port => '42', :protocol => 'tcp'} }

    it 'should remove Package[ntp]' do should contain_package('ntp').with_ensure('absent') end 
    it 'should stop Service[ntp]' do should contain_service('ntp').with_ensure('stopped') end
    it 'should not enable at boot Service[ntp]' do should contain_service('ntp').with_enable('false') end
    it 'should remove ntp configuration file' do should contain_file('ntp.conf').with_ensure('absent') end
    it 'should not monitor the process' do
      content = catalogue.resource('monitor::process', 'ntp_process').send(:parameters)[:enable]
      content.should == false
    end
    it 'should remove a firewall rule' do
      content = catalogue.resource('firewall', 'ntp_tcp_42').send(:parameters)[:enable]
      content.should == false
    end
  end

  describe 'Test decommissioning - disable' do
    let(:params) { {:disable => true, :monitor => true , :firewall => true, :port => '42', :protocol => 'tcp'} }

    it { should contain_package('ntp').with_ensure('present') }
    it 'should stop Service[ntp]' do should contain_service('ntp').with_ensure('stopped') end
    it 'should not enable at boot Service[ntp]' do should contain_service('ntp').with_enable('false') end
    it { should contain_file('ntp.conf').with_ensure('present') }
    it 'should not monitor the process' do
      content = catalogue.resource('monitor::process', 'ntp_process').send(:parameters)[:enable]
      content.should == false
    end
    it 'should remove a firewall rule' do
      content = catalogue.resource('firewall', 'ntp_tcp_42').send(:parameters)[:enable]
      content.should == false
    end
  end

  describe 'Test decommissioning - disableboot' do
    let(:params) { {:disableboot => true, :monitor => true , :firewall => true, :port => '42', :protocol => 'tcp'} }
  
    it { should contain_package('ntp').with_ensure('present') }
    it { should_not contain_service('ntp').with_ensure('present') }
    it { should_not contain_service('ntp').with_ensure('absent') }
    it 'should not enable at boot Service[ntp]' do should contain_service('ntp').with_enable('false') end
    it { should contain_file('ntp.conf').with_ensure('present') }
    it 'should not monitor the process locally' do
      content = catalogue.resource('monitor::process', 'ntp_process').send(:parameters)[:enable]
      content.should == false
    end
    it 'should keep a firewall rule' do
      content = catalogue.resource('firewall', 'ntp_tcp_42').send(:parameters)[:enable]
      content.should == true
    end
  end 

  describe 'Test customizations - template' do
    let(:params) { {:template => "ntp/spec.erb" , :options => { 'opt_a' => 'value_a' } } }

    it 'should generate a valid template' do
      content = catalogue.resource('file', 'ntp.conf').send(:parameters)[:content]
      content.should match "fqdn: rspec.example42.com"
    end
    it 'should generate a template that uses custom options' do
      content = catalogue.resource('file', 'ntp.conf').send(:parameters)[:content]
      content.should match "value_a"
    end
    it 'should not use source parameters' do
      content = catalogue.resource('file', 'ntp.conf').send(:parameters)[:source]
      content.should be_nil
    end
  end

  describe 'Test customizations - source' do
    let(:params) { {:source => "puppet://modules/ntp/spec" , :source_dir => "puppet://modules/ntp/dir/spec" , :source_dir_purge => true, :template => '' } }

    it 'should request a valid source ' do
      content = catalogue.resource('file', 'ntp.conf').send(:parameters)[:source]
      content.should == "puppet://modules/ntp/spec"
    end
    it 'should request a valid source dir' do
      content = catalogue.resource('file', 'ntp.dir').send(:parameters)[:source]
      content.should == "puppet://modules/ntp/dir/spec"
    end
    it 'should purge source dir if source_dir_purge is true' do
      content = catalogue.resource('file', 'ntp.dir').send(:parameters)[:purge]
      content.should == true
    end
    it 'should not use template parameters' do
      content = catalogue.resource('file', 'ntp.conf').send(:parameters)[:content]
      content.should be_nil
    end
  end

  describe 'Test customizations - custom class' do
    let(:params) { {:my_class => "ntp::spec" } }
    it 'should automatically include a custom class' do
      content = catalogue.resource('file', 'ntp.conf').send(:parameters)[:content]
      content.should match "fqdn: rspec.example42.com"
    end
  end

  describe 'Test service autorestart', :broken => true do
    it 'should automatically restart the service, by default' do
      content = catalogue.resource('file', 'ntp.conf').send(:parameters)[:notify]
      content.should == 'Service[ntp]{:name=>"ntp"}'
    end
  end

  describe 'Test service autorestart' do
    let(:params) { {:service_autorestart => "no" } }

    it 'should not automatically restart the service, when service_autorestart => false' do
      content = catalogue.resource('file', 'ntp.conf').send(:parameters)[:notify]
      content.should be_nil
    end
  end

  describe 'Test Puppi Integration' do
    let(:params) { {:puppi => true, :puppi_helper => "myhelper"} }

    it 'should generate a puppi::ze define' do
      content = catalogue.resource('puppi::ze', 'ntp').send(:parameters)[:helper]
      content.should == "myhelper"
    end
  end

  describe 'Test Monitoring Tools Integration' do
    let(:params) { {:monitor => true, :monitor_tool => "puppi" } }

    it 'should generate monitor defines' do
      content = catalogue.resource('monitor::process', 'ntp_process').send(:parameters)[:tool]
      content.should == "puppi"
    end
  end

  describe 'Test Firewall Tools Integration' do
    let(:params) { {:firewall => true, :firewall_tool => "iptables" , :protocol => "tcp" , :port => "42" } }

    it 'should generate correct firewall define' do
      content = catalogue.resource('firewall', 'ntp_tcp_42').send(:parameters)[:tool]
      content.should == "iptables"
    end
  end

  describe 'Test OldGen Module Set Integration' do
    let(:params) { {:monitor => "yes" , :monitor_tool => "puppi" , :firewall => "yes" , :firewall_tool => "iptables" , :puppi => "yes" , :port => "42" , :protocol => 'tcp' } }

    it 'should generate monitor resources' do
      content = catalogue.resource('monitor::process', 'ntp_process').send(:parameters)[:tool]
      content.should == "puppi"
    end
    it 'should generate firewall resources' do
      content = catalogue.resource('firewall', 'ntp_tcp_42').send(:parameters)[:tool]
      content.should == "iptables"
    end
    it 'should generate puppi resources ' do 
      content = catalogue.resource('puppi::ze', 'ntp').send(:parameters)[:ensure]
      content.should == "present"
    end
  end

  describe 'Test params lookup' do
    let(:facts) { { :monitor => true , :ipaddress => '10.42.42.42' } }
    let(:params) { { :port => '42' } }

    it 'should honour top scope global vars' do
      content = catalogue.resource('monitor::process', 'ntp_process').send(:parameters)[:enable]
      content.should == true
    end
  end

  describe 'Test params lookup' do
    let(:facts) { { :ntp_monitor => true , :ipaddress => '10.42.42.42' } }
    let(:params) { { :port => '42' } }

    it 'should honour module specific vars' do
      content = catalogue.resource('monitor::process', 'ntp_process').send(:parameters)[:enable]
      content.should == true
    end
  end

  describe 'Test params lookup' do
    let(:facts) { { :monitor => false , :ntp_monitor => true , :ipaddress => '10.42.42.42' } }
    let(:params) { { :port => '42' } }

    it 'should honour top scope module specific over global vars' do
      content = catalogue.resource('monitor::process', 'ntp_process').send(:parameters)[:enable]
      content.should == true
    end
  end

  describe 'Test params lookup' do
    let(:facts) { { :monitor => false , :ipaddress => '10.42.42.42' } }
    let(:params) { { :monitor => true , :firewall => true, :port => '42' } }

    it 'should honour passed params over global vars' do
      content = catalogue.resource('monitor::process', 'ntp_process').send(:parameters)[:enable]
      content.should == true
    end
  end

end

