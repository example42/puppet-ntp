# Class: ntp::params
#
# This class defines default parameters used by the main module class ntp
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to ntp class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes
#
class ntp::params {

  ### Module specific parameters
  $server = [ '0.pool.ntp.org', '1.pool.ntp.org', '2.pool.ntp.org', '3.pool.ntp.org' ]
  $runmode = 'service'
  $cron_command = 'ntpd -q'

  $keys_file = $::operatingsystem ? {
    'Solaris'            => '/etc/inet/ntp.keys',
    /(?i:SLES|OpenSuSE)/ => '/etc/ntp.keys',
    default              => '/etc/ntp/keys',
  }
  $keys_file_source = ''

  ### Application related parameters

  $package = $::operatingsystem ? {
    'Solaris'      => $::operatingsystemrelease ? {
      '5.10'       => [ 'SUNWntpr' , 'SUNWntpu' ],
      default      => 'ntp',
    },
    /(?i:FreeBSD)/ => '',  # Package resides in base
    default        => 'ntp',
  }
  $ntpdate_package = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => 'ntpdate',
    'Solaris'                 => $::operatingsystemrelease ? {
      '5.10'  => [ 'SUNWntpr' , 'SUNWntpu' ],
      default => 'ntp',
    },
    /(?i:FreeBSD)/ => '',  # Package resides in base
    default                   => 'ntp',
  }

  $service = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint|Solaris)/ => 'ntp',
    /(?i:SLES|OpenSuSE)/              => 'ntp',
    default                           => 'ntpd',
  }

  $service_status = $::operatingsystem ? {
    default => true,
  }

  $process = $::operatingsystem ? {
    default => 'ntpd',
  }

  $process_args = $::operatingsystem ? {
    default => '',
  }

  $process_user = $::operatingsystem ? {
    default => 'ntp',
  }

  $config_dir = $::operatingsystem ? {
    'Solaris' => '/etc/inet',
    default   => '/etc/ntp',
  }

  $config_file = $::operatingsystem ? {
    'Solaris' => '/etc/inet/ntp.conf',
    default   => '/etc/ntp.conf',
  }

  $config_file_mode = $::operatingsystem ? {
    /(?i:SLES|OpenSuSE)/ => '0640',
    default              => '0644',
  }

  $config_file_owner = $::operatingsystem ? {
    default => 'root',
  }

  $config_file_group = $::operatingsystem ? {
    /(?i:SLES|OpenSuSE)/ => 'ntp',
    /(?i:FreeBSD)/       => 'wheel',
    default              => 'root',
  }

  $config_file_init = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => '/etc/default/ntp',
    default                   => '/etc/sysconfig/ntpd',
  }

  $pid_file = $::operatingsystem ? {
    'Solaris' => '/var/run/ntp.pid',
    default   => '/var/run/ntpd.pid',
  }

  $data_dir = $::operatingsystem ? {
    'Solaris' => '/var/ntp',
    default   => '/var/lib/ntp',
  }

  $log_dir = $::operatingsystem ? {
    default => '',
  }

  $log_file = $::operatingsystem ? {
    default => '',
  }

  $drift_file = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint|Solaris)/ => "$data_dir/ntp.drift",
    default                           => "$data_dir/drift",
  }

  $use_local_clock = $::virtual ? {
    'vmware' => false, # See http://www.vmware.com/pdf/vmware_timekeeping.pdf page 18
    default  => true,
  }

  $tinker_panic = $::virtual ? {
    'vmware' => 0, # See http://www.vmware.com/pdf/vmware_timekeeping.pdf page 18
    default  => '',
  }

  $time_zone_file = $::operatingsystem ? {
    default => '/etc/localtime',
  }

  $time_zone_owner = $::operatingsystem ? {
    default => 'root',
  }

  $time_zone_group = $::operatingsystem ? {
    'FreeBSD' => 'wheel',
    default   => 'root',
  }

  $time_zone_mode = $::operatingsystem ? {
    default => '0444',
  }
 
  $time_zone_path = $::operatingsystem ? {
    default => '/usr/share/zoneinfo/',
  }

  $port = '123'
  $protocol = 'udp'

  # General Settings
  $my_class = ''
  $source = ''
  $source_dir = ''
  $source_dir_purge = false
  $template = 'ntp/ntp.conf.erb'
  $options = ''
  $service_autorestart = true
  $version = 'present'
  $absent = false
  $disable = false
  $disableboot = false

  ### General module variables that can have a site or per module default
  $monitor = false
  $monitor_tool = ''
  $monitor_target = $::ipaddress
  $firewall = true
  $puppi = false
  $puppi_helper = 'standard'
  $debug = false
  $audit_only = false

}
