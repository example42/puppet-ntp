require 'spec_helper'

describe 'ntp' do

  let(:title) { 'ntp' }
  let(:node) { 'rspec.example42.com' }
  let :facts do
    {
      :ipaddress                 => '10.42.42.42',
      :id                        => 'root',
      :osfamily                  => 'Debian',
      :kernel                    => 'Linux',
      :operatingsystem           => 'Debian',
      :operatingsystemrelease    => '7.8',
      :operatingsystemmajrelease => '7',
      :virtual                   => 'physical',
      :path                      => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      :concat_basedir            => '/dne',
      # Strict variables
      # :puppi_archivedir          => nil,
      # :puppi_workdir             => nil,
      # :ntp_server                => nil,
    }
  end

  describe 'Test standard installation' do
    it { should contain_package('ntp').with_ensure('present') }
    it { should contain_package('ntp').with_name('ntp') }
    it { should contain_service('ntp').with_ensure('running') }
    it { should contain_service('ntp').with_enable('true') }
    it { should contain_file('ntp.conf').with_ensure('present') }
    it { should contain_file('ntp.cron').with_ensure('absent') }
    it 'should generate a valid default template' do
      should contain_file('ntp.conf').with_content(/server 1.pool.ntp.org/)
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
      should contain_monitor__process('ntp_process').with_enable(true)
    end
    it 'should place a firewall rule' do
      should contain_firewall('ntp_tcp_42').with_enable(true)
    end
  end

  describe 'Test server parameter as arrays' do
    let(:params) { {:server => ['server1', 'server2'] } }

    it 'should generate a valid default template' do
      should contain_file('ntp.conf').with(
          'content' => /server server1/,
          'content' => /server server2/
      )
    end
  end

  describe 'Test server parameter as strings' do
    let(:params) { {:server => 'server1,server2' } }

    it 'should generate a valid default template' do
      should contain_file('ntp.conf').with(
        'content' => /server server1/,
        'content' => /server server2/
      )
    end
  end

  context "on Debian" do
    let :facts do
      super().merge({
        :operatingsystem           => 'Debian',
        :operatingsystemrelease    => '7.8',
        :operatingsystemmajrelease => '7',
      })
    end
    describe 'Test install with cron runmode on Debian' do
      let(:params) { {:runmode => 'cron', :server => ['server1', 'server2'] } }

      it { should contain_package('ntp').with_ensure('present') }
      it { should contain_package('ntp').with_name('ntpdate') }
      it { should_not contain_service('ntp').with_ensure('stopped') }
      it { should_not contain_service('ntp').with_enable('false') }
      it { should contain_file('ntp.conf').with_ensure('present') }
      it { should contain_file('ntp.cron').with_ensure('present') }
      it 'should generate a valid default template' do
        should contain_file('ntp.cron').with_content(/ntpd -q/)
      end
    end
  end

  describe 'Test decommissioning - absent' do
    let(:params) { {:absent => true, :monitor => true , :firewall => true, :port => '42', :protocol => 'tcp'} }

    it 'should remove Package[ntp]' do should contain_package('ntp').with_ensure('absent') end 
    it 'should not manage Service[ntp]' do should_not contain_service('ntp') end
    it 'should remove ntp configuration file' do should contain_file('ntp.conf').with_ensure('absent') end
    it 'should not monitor the process' do
      should contain_monitor__process('ntp_process').with_enable(false)
    end
    it 'should remove a firewall rule' do
      should contain_firewall('ntp_tcp_42').with_enable(false)
    end
  end

  describe 'Test decommissioning - disable' do
    let(:params) { {:disable => true, :monitor => true , :firewall => true, :port => '42', :protocol => 'tcp'} }

    it { should contain_package('ntp').with_ensure('present') }
    it 'should stop Service[ntp]' do should contain_service('ntp').with_ensure('stopped') end
    it 'should not enable at boot Service[ntp]' do should contain_service('ntp').with_enable('false') end
    it { should contain_file('ntp.conf').with_ensure('present') }
    it 'should not monitor the process' do
      should contain_monitor__process('ntp_process').with_enable(false)
    end
    it 'should remove a firewall rule' do
      should contain_firewall('ntp_tcp_42').with_enable(false)
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
      should contain_monitor__process('ntp_process').with_enable(false)
    end
    it 'should keep a firewall rule' do
      should contain_firewall('ntp_tcp_42').with_enable(true)
    end
  end 

  describe 'Test customizations - template' do
    let(:params) { {:template => "ntp/spec.erb" , :options => { 'opt_a' => 'value_a' } } }

    it 'should generate a valid template' do
      should contain_file('ntp.conf').with_content(/fqdn: rspec.example42.com/)
    end
    it 'should generate a template that uses custom options' do
      should contain_file('ntp.conf').with_content(/value_a/)
    end
    it 'should not use source parameters' do
      should contain_file('ntp.conf').with_source(nil)
    end
  end

  describe 'Test customizations - source' do
    let(:params) { {:source => "puppet://modules/ntp/spec" , :source_dir => "puppet://modules/ntp/dir/spec" , :source_dir_purge => true, :template => '' } }

    it 'should request a valid source ' do
      should contain_file('ntp.conf').with_source("puppet://modules/ntp/spec")
    end
    it 'should request a valid source dir' do
      should contain_file('ntp.dir').with_source("puppet://modules/ntp/dir/spec")
    end
    it 'should purge source dir if source_dir_purge is true' do
      should contain_file('ntp.dir').with_purge(true)
    end
    it 'should not use template parameters' do
      should contain_file('ntp.conf').with_content(nil)
    end
  end

  describe 'Test customizations - custom class' do
    let(:params) { {:my_class => "ntp::spec" } }
    it 'should automatically include a custom class' do
      should contain_file('ntp.conf').with_content(/fqdn: rspec.example42.com/)
    end
  end

  describe 'Test service autorestart' do
    it { should contain_file('ntp.conf').with_notify('Service[ntp]') }
  end

  describe 'Test service autorestart' do
    let(:params) { {:service_autorestart => "no" } }

    it 'should not automatically restart the service, when service_autorestart => false' do
      should contain_file('ntp.conf').with_notify(nil)
    end
  end

  describe 'Test Puppi Integration' do
    let(:params) { {:puppi => true, :puppi_helper => "myhelper"} }

    it 'should generate a puppi::ze define' do
      should contain_puppi__ze('ntp').with_helper("myhelper")
    end
  end

  describe 'Test Monitoring Tools Integration' do
    let(:params) { {:monitor => true, :monitor_tool => "puppi" } }

    it 'should generate monitor defines' do
      should contain_monitor__process('ntp_process').with_tool("puppi")
    end
  end

  describe 'Test Firewall Tools Integration' do
    let(:params) { {:firewall => true, :firewall_tool => "iptables" , :protocol => "tcp" , :port => "42" } }

    it 'should generate correct firewall define' do
      should contain_firewall('ntp_tcp_42').with_tool("iptables")
    end
  end

  describe 'Test OldGen Module Set Integration' do
    let(:params) { {:monitor => "yes" , :monitor_tool => "puppi" , :firewall => "yes" , :firewall_tool => "iptables" , :puppi => "yes" , :port => "42" , :protocol => 'tcp' } }

    it 'should generate monitor resources' do
      should contain_monitor__process('ntp_process').with_tool("puppi")
    end
    it 'should generate firewall resources' do
      should contain_firewall('ntp_tcp_42').with_tool("iptables")
    end
    it 'should generate puppi resources ' do 
      should contain_puppi__ze('ntp').with_ensure("present")
    end
  end

  describe 'Test params lookup' do
    let :facts do
      super().merge({
        :monitor => true,
      })
    end
    let(:params) { { :port => '42' } }

    it 'should honour top scope global vars' do
      should contain_monitor__process('ntp_process').with_enable(true)
    end
  end

  describe 'Test params lookup' do
    let :facts do
      super().merge({
        :ntp_monitor => true,
      })
    end
    let(:params) { { :port => '42' } }

    it 'should honour module specific vars' do
      should contain_monitor__process('ntp_process').with_enable(true)
    end
  end

  describe 'Test params lookup' do
    let :facts do
      super().merge({
        :monitor    => false,
        :ntp_monitor => true,
      })
    end
    let(:params) { { :port => '42' } }

    it 'should honour top scope module specific over global vars' do
      should contain_monitor__process('ntp_process').with_enable(true)
    end
  end

  describe 'Test params lookup' do
    let :facts do
      super().merge({
        :monitor    => false,
      })
    end
    let(:params) { { :monitor => true , :firewall => true, :port => '42' } }

    it 'should honour passed params over global vars' do
      should contain_monitor__process('ntp_process').with_enable(true)
    end
  end

end

