# = Class: ntp
#
# This is the main ntp class
#
#
# == Parameters
#
# Module specific parameters
#
# [*server*]
#   Name or ip of ntp server(s). Can be an array.
#
# [*runmode*]
#   How to manage ntp syncs
#   To enable ntp service (default)      runmode => service
#   To schedule ntpdaty hourly cronjobs  runmode => cron
#
# [*cron_command*]
#   The command to execute when runmode=cron
#   This was historically ntpdate but on more recent ntp versions it has
#   been deprecated.
#   Default: 'ntpd -q'
#   TO similate the previous behaviour
#   cron_command => 'ntpdate my.time.server',
#
# [*keys_file*]
#   Path of ntp keys file
#
# [*keys_file_source*]
#   Source file for the keys
#
# Standard class parameters
# Define the general class behaviour and customizations
#
# [*my_class*]
#   Name of a custom class to autoload to manage module's customizations
#   If defined, ntp class will automatically "include $my_class"
#   Can be defined also by the (top scope) variable $ntp_myclass
#
# [*source*]
#   Sets the content of source parameter for main configuration file
#   If defined, ntp main config file will have the param: source => $source
#   Can be defined also by the (top scope) variable $ntp_source
#
# [*source_dir*]
#   If defined, the whole ntp configuration directory content is retrieved
#   recursively from the specified source
#   (source => $source_dir , recurse => true)
#   Can be defined also by the (top scope) variable $ntp_source_dir
#
# [*source_dir_purge*]
#   If set to true (default false) the existing configuration directory is
#   mirrored with the content retrieved from source_dir
#   (source => $source_dir , recurse => true , purge => true)
#   Can be defined also by the (top scope) variable $ntp_source_dir_purge
#
# [*template*]
#   Sets the path to the template to use as content for main configuration file
#   If defined, ntp main config file has: content => content("$template")
#   Note source and template parameters are mutually exclusive: don't use both
#   Can be defined also by the (top scope) variable $ntp_template
#
# [*options*]
#   An hash of custom options to be used in templates for arbitrary settings.
#   Can be defined also by the (top scope) variable $ntp_options
#
# [*service_autorestart*]
#   Automatically restarts the ntp service when there is a change in
#   configuration files. Default: true, Set to false if you don't want to
#   automatically restart the service.
#
# [*version*]
#   The package version, used in the ensure parameter of package type.
#   Default: present. Can be 'latest' or a specific version number.
#   Note that if the argument absent (see below) is set to true, the
#   package is removed, whatever the value of version parameter.
#
# [*absent*]
#   Set to 'true' to remove package(s) installed by module
#   Can be defined also by the (top scope) variable $ntp_absent
#
# [*disable*]
#   Set to 'true' to disable service(s) managed by module
#   Can be defined also by the (top scope) variable $ntp_disable
#
# [*disableboot*]
#   Set to 'true' to disable service(s) at boot, without checks if it's running
#   Use this when the service is managed by a tool like a cluster software
#   Can be defined also by the (top scope) variable $ntp_disableboot
#
# [*monitor*]
#   Set to 'true' to enable monitoring of the services provided by the module
#   Can be defined also by the (top scope) variables $ntp_monitor
#   and $monitor
#
# [*monitor_tool*]
#   Define which monitor tools (ad defined in Example42 monitor module)
#   you want to use for ntp checks
#   Can be defined also by the (top scope) variables $ntp_monitor_tool
#   and $monitor_tool
#
# [*monitor_target*]
#   The Ip address or hostname to use as a target for monitoring tools.
#   Default is the fact $ipaddress
#   Can be defined also by the (top scope) variables $ntp_monitor_target
#   and $monitor_target
#
# [*puppi*]
#   Set to 'true' to enable creation of module data files that are used by puppi
#   Can be defined also by the (top scope) variables $ntp_puppi and $puppi
#
# [*puppi_helper*]
#   Specify the helper to use for puppi commands. The default for this module
#   is specified in params.pp and is generally a good choice.
#   You can customize the output of puppi commands for this module using another
#   puppi helper. Use the define puppi::helper to create a new custom helper
#   Can be defined also by the (top scope) variables $ntp_puppi_helper
#   and $puppi_helper
#
# [*firewall*]
#   Set to 'true' to enable firewalling of the services provided by the module
#   Can be defined also by the (top scope) variables $ntp_firewall
#   and $firewall
#
# [*debug*]
#   Set to 'true' to enable modules debugging
#   Can be defined also by the (top scope) variables $ntp_debug and $debug
#
# [*audit_only*]
#   Set to 'true' if you don't intend to override existing configuration files
#   and want to audit the difference between existing files and the ones
#   managed by Puppet.
#   Can be defined also by the (top scope) variables $ntp_audit_only
#   and $audit_only
#
# Default class params - As defined in ntp::params.
# Note that these variables are mostly defined and used in the module itself,
# overriding the default values might not affected all the involved components.
# Set and override them only if you know what you're doing.
# Note also that you can't override/set them via top scope variables.
#
# [*package*]
#   The name of ntp package
#
# [*service*]
#   The name of ntp service
#
# [*service_status*]
#   If the ntp service init script supports status argument
#
# [*process*]
#   The name of ntp process
#
# [*process_args*]
#   The name of ntp arguments. Used by puppi and monitor.
#   Used only in case the ntp process name is generic (java, ruby...)
#
# [*process_user*]
#   The name of the user ntp runs with. Used by puppi and monitor.
#
# [*config_dir*]
#   Main configuration directory. Used by puppi
#
# [*config_file*]
#   Main configuration file path
#
# [*config_file_mode*]
#   Main configuration file path mode
#
# [*config_file_owner*]
#   Main configuration file path owner
#
# [*config_file_group*]
#   Main configuration file path group
#
# [*config_file_init*]
#   Path of configuration file sourced by init script
#
# [*pid_file*]
#   Path of pid file. Used by monitor
#
# [*data_dir*]
#   Path of application data directory. Used by puppi
#
# [*log_dir*]
#   Base logs directory. Used by puppi
#
# [*log_file*]
#   Log file(s). Used by puppi
#
# [*port*]
#   The listening port, if any, of the service.
#   This is used by monitor, firewall and puppi (optional) components
#   Note: This doesn't necessarily affect the service configuration file
#   Can be defined also by the (top scope) variable $ntp_port
#
# [*protocol*]
#   The protocol used by the the service.
#   This is used by monitor, firewall and puppi (optional) components
#   Can be defined also by the (top scope) variable $ntp_protocol
#
# [*time_zone*]
#   When set, puppet sets the right time zone from the zoneinfo files
#
# == Examples
#
# You can use this class in 2 ways:
# - Set variables (at top scope level on in a ENC) and "include ntp"
# - Call ntp as a parametrized class
#
# See README for details.
#
#
# == Author
#   Alessandro Franceschi <al@lab42.it/>
#
class ntp (
  $server              = params_lookup( 'server' ),
  $runmode             = params_lookup( 'runmode' ),
  $cron_command        = params_lookup( 'cron_command' ),
  $keys_file           = params_lookup( 'keys_file' ),
  $keys_file_source    = params_lookup( 'keys_file_source' ),
  $my_class            = params_lookup( 'my_class' ),
  $source              = params_lookup( 'source' ),
  $source_dir          = params_lookup( 'source_dir' ),
  $source_dir_purge    = params_lookup( 'source_dir_purge' ),
  $template            = params_lookup( 'template' ),
  $service_autorestart = params_lookup( 'service_autorestart' , 'global' ),
  $options             = params_lookup( 'options' ),
  $version             = params_lookup( 'version' ),
  $absent              = params_lookup( 'absent' ),
  $disable             = params_lookup( 'disable' ),
  $disableboot         = params_lookup( 'disableboot' ),
  $monitor             = params_lookup( 'monitor' , 'global' ),
  $monitor_tool        = params_lookup( 'monitor_tool' , 'global' ),
  $monitor_target      = params_lookup( 'monitor_target' , 'global' ),
  $puppi               = params_lookup( 'puppi' , 'global' ),
  $puppi_helper        = params_lookup( 'puppi_helper' , 'global' ),
  $firewall            = params_lookup( 'firewall' , 'global' ),
  $debug               = params_lookup( 'debug' , 'global' ),
  $audit_only          = params_lookup( 'audit_only' , 'global' ),
  $package             = params_lookup( 'package' ),
  $ntpdate_package     = params_lookup( 'ntpdate_package' ),
  $service             = params_lookup( 'service' ),
  $service_status      = params_lookup( 'service_status' ),
  $process             = params_lookup( 'process' ),
  $process_args        = params_lookup( 'process_args' ),
  $process_user        = params_lookup( 'process_user' ),
  $config_dir          = params_lookup( 'config_dir' ),
  $config_file         = params_lookup( 'config_file' ),
  $config_file_mode    = params_lookup( 'config_file_mode' ),
  $config_file_owner   = params_lookup( 'config_file_owner' ),
  $config_file_group   = params_lookup( 'config_file_group' ),
  $config_file_init    = params_lookup( 'config_file_init' ),
  $pid_file            = params_lookup( 'pid_file' ),
  $data_dir            = params_lookup( 'data_dir' ),
  $log_dir             = params_lookup( 'log_dir' ),
  $log_file            = params_lookup( 'log_file' ),
  $drift_file          = params_lookup( 'drift_file' ),
  $use_local_clock     = params_lookup( 'use_local_clock' ),
  $tinker_panic        = params_lookup( 'tinker_panic' ),
  $port                = params_lookup( 'port' ),
  $protocol            = params_lookup( 'protocol' ),
  $time_zone           = params_lookup( 'time_zone' )
  ) inherits ntp::params {

  $bool_source_dir_purge=any2bool($source_dir_purge)
  $bool_service_autorestart=any2bool($service_autorestart)
  $bool_absent=any2bool($absent)
  $bool_disable=any2bool($disable)
  $bool_disableboot=any2bool($disableboot)
  $bool_monitor=any2bool($monitor)
  $bool_puppi=any2bool($puppi)
  $bool_firewall=any2bool($firewall)
  $bool_debug=any2bool($debug)
  $bool_audit_only=any2bool($audit_only)
  $bool_use_local_clock=any2bool($use_local_clock)
  $array_servers = is_array($ntp::server) ? {
    false     => $ntp::server ? {
      ''      => [],
      default => split($ntp::server, ','),
    },
    default   => $ntp::server,
  }

  ### Definition of some variables used in the module
  $first_server = $array_servers[0]

  $manage_package = $ntp::bool_absent ? {
    true  => 'absent',
    false => $ntp::version,
  }
  $real_package = $ntp::runmode ? {
    service => $ntp::package,
    cron    => $ntp::ntpdate_package,
  }

  $manage_service_enable = $ntp::bool_disableboot ? {
    true    => false,
    default => $ntp::bool_disable ? {
      true    => false,
      default => $ntp::bool_absent ? {
        true  => false,
        false => $ntp::runmode ? {
          cron    => false,
          service => true,
        },
      },
    },
  }

  $manage_service_ensure = $ntp::bool_disable ? {
    true    => 'stopped',
    default =>  $ntp::bool_absent ? {
      true    => 'stopped',
      default => $ntp::runmode ? {
        'cron'    => 'stopped',
        'service' => 'running',
      },
    },
  }

  $manage_service_autorestart = $ntp::bool_service_autorestart ? {
    true    => $ntp::runmode ? {
      service => Service[ntp],
      cron    => undef,
    },
    false   => undef,
  }

  $manage_file = $ntp::bool_absent ? {
    true    => 'absent',
    default => 'present',
  }

  $manage_file_cron = $ntp::runmode ? {
    service => 'absent',
    cron    => 'present',
  }

  if $ntp::bool_absent == true
  or $ntp::bool_disable == true
  or $ntp::bool_disableboot == true {
    $manage_monitor = false
  } else {
    $manage_monitor = true
  }

  if $ntp::bool_absent == true
  or $ntp::bool_disable == true {
    $manage_firewall = false
  } else {
    $manage_firewall = true
  }

  $manage_audit = $ntp::bool_audit_only ? {
    true  => 'all',
    false => undef,
  }

  $manage_file_replace = $ntp::bool_audit_only ? {
    true  => false,
    false => true,
  }

  $manage_file_source = $ntp::source ? {
    ''        => undef,
    default   => $ntp::source,
  }

  $manage_file_content = $ntp::template ? {
    ''        => undef,
    default   => template($ntp::template),
  }

  $manage_time_zone = $ntp::time_zone_file ? {
    ''      => false,
    default => $time_zone ? {
      ''      => false,
      default => true,
    }
  }

  ### Managed resources
  # On systems like FreeBSD theres' no ntp package as it is in base
  if $ntp::real_package == '' {
    package { 'ntp':
      ensure => $ntp::manage_package,
      name   => 'ntp',
      noop   => true
    }

  } else {
    package { 'ntp':
      ensure => $ntp::manage_package,
      name   => $ntp::real_package,
    }
  }

  if $runmode == 'service' and !$ntp::bool_absent {
    service { 'ntp':
      ensure     => $ntp::manage_service_ensure,
      name       => $ntp::service,
      enable     => $ntp::manage_service_enable,
      hasstatus  => $ntp::service_status,
      pattern    => $ntp::process,
      require    => Package['ntp'],
    }
  }

  file { 'ntp.cron':
    ensure  => $ntp::manage_file_cron,
    path    => '/etc/cron.hourly/ntpdate',
    mode    => '0755',
    owner   => $ntp::config_file_owner,
    group   => $ntp::config_file_group,
    require => Package['ntp'],
    content => template('ntp/ntpdate.erb'),
    replace => $ntp::manage_file_replace,
    audit   => $ntp::manage_audit,
  }

  file { 'ntp.conf':
    ensure  => $ntp::manage_file,
    path    => $ntp::config_file,
    mode    => $ntp::config_file_mode,
    owner   => $ntp::config_file_owner,
    group   => $ntp::config_file_group,
    require => Package['ntp'],
    notify  => $ntp::manage_service_autorestart,
    source  => $ntp::manage_file_source,
    content => $ntp::manage_file_content,
    replace => $ntp::manage_file_replace,
    audit   => $ntp::manage_audit,
  }

  # The whole ntp configuration directory can be recursively overriden
  if $ntp::source_dir {
    file { 'ntp.dir':
      ensure  => directory,
      path    => $ntp::config_dir,
      require => Package['ntp'],
      notify  => $ntp::manage_service_autorestart,
      source  => $ntp::source_dir,
      recurse => true,
      purge   => $ntp::bool_source_dir_purge,
      replace => $ntp::manage_file_replace,
      audit   => $ntp::manage_audit,
    }
  }

  # The ntp keys file is managed if exists a source
  if $ntp::keys_file_source {
    file { 'ntp.key':
      ensure  => $ntp::manage_file,
      path    => $ntp::keys_file,
      mode    => '0600',
      owner   => $ntp::config_file_owner,
      group   => $ntp::config_file_group,
      require => Package['ntp'],
      notify  => $ntp::manage_service_autorestart,
      source  => $ntp::keys_file_source,
      replace => $ntp::manage_file_replace,
      audit   => $ntp::manage_audit,
    }
  }

  ### Include custom class if $my_class is set
  if $ntp::my_class {
    include $ntp::my_class
  }


  ### Provide puppi data, if enabled ( puppi => true )
  if $ntp::bool_puppi == true {
    $classvars=get_class_args()
    puppi::ze { 'ntp':
      ensure    => $ntp::manage_file,
      variables => $classvars,
      helper    => $ntp::puppi_helper,
    }
  }


  ### Service monitoring, if enabled ( monitor => true )
  if $ntp::bool_monitor == true and $ntp::runmode == 'service' {

    if $ntp::protocol == 'tcp' {
      monitor::port { "ntp_${ntp::protocol}_${ntp::port}":
        protocol => $ntp::protocol,
        port     => $ntp::port,
        target   => $ntp::monitor_target,
        tool     => $ntp::monitor_tool,
        enable   => $ntp::manage_monitor,
      }
    }
    monitor::process { 'ntp_process':
      process  => $ntp::process,
      service  => $ntp::service,
      pidfile  => $ntp::pid_file,
      user     => $ntp::process_user,
      argument => $ntp::process_args,
      tool     => $ntp::monitor_tool,
      enable   => $ntp::manage_monitor,
    }
  }

  # Time Monitoring
  if $ntp::bool_monitor == true {
    monitor::plugin { "ntp_time":
      plugin    => 'check_ntp',
      arguments => "-H $ntp::first_server",
      tool      => $ntp::monitor_tool,
      enable    => $ntp::manage_monitor,
    }
  }

  # Time zone
  if $ntp::manage_time_zone == true {
    if $::osfamily == 'Solaris' {
        file_line { 'ntp_localtime':
          path  => '/etc/default/init',
          line  => "TZ=${time_zone}",
          match => '^TZ=',
        }
    } else {
      file { 'ntp_localtime':
        ensure => file,
        force  => true,
        name   => $ntp::time_zone_file,
        owner  => $ntp::time_zone_owner,
        group  => $ntp::time_zone_group,
        mode   => $ntp::time_zone_mode,
        source => "${ntp::time_zone_path}/${time_zone}",
      }
    }
  }

  ### Firewall management, if enabled ( firewall => true )
  if $ntp::bool_firewall == true {
    firewall::rule { "ntp_${ntp::protocol}_${ntp::port}-out":
      protocol       => $ntp::protocol,
      port           => $ntp::port,
      action         => 'allow',
      direction      => 'output',
      enable         => $ntp::manage_firewall,
    }

    firewall::rule { "ntp_${ntp::protocol}_${ntp::port}-in":
      protocol                  => $ntp::protocol,
      port                      => $ntp::port,
      action                    => 'allow',
      direction                 => 'input',
      iptables_explicit_matches => { 'state' => { 'state' => 'RELATED,ESTABLISHED' } },
      enable                    => $ntp::manage_firewall,
    }
  }

  ### Debugging, if enabled ( debug => true )
  if $ntp::bool_debug == true {
    file { 'debug_ntp':
      ensure  => $ntp::manage_file,
      path    => "${settings::vardir}/debug-ntp",
      mode    => '0640',
      owner   => 'root',
      group   => 'root',
      content => inline_template('<%= scope.to_hash.reject { |k,v| k.to_s =~ /(uptime.*|path|timestamp|free|.*password.*|.*psk.*|.*key)/ }.to_yaml %>'),
    }
  }

}
