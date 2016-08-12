# Deprecation notice

This module was designed for Puppet versions 2 and 3. It should work also on Puppet 4 but doesn't use any of its features.

The current Puppet 3 compatible codebase is no longer actively maintained by example42.

Still, Pull Requests that fix bugs or introduce backwards compatible features will be accepted.


# Puppet module: ntp

This is a Puppet module for ntp based on the second generation layout ("NextGen") of Example42 Puppet Modules.

Made by Alessandro Franceschi / Lab42

Official site: http://www.example42.com

Official git repository: http://github.com/example42/puppet-ntp

Released under the terms of Apache 2 License.

This module requires functions provided by the Example42 Puppi module (you need it even if you don't use and install Puppi)

For detailed info about the logic and usage patterns of Example42 modules check the DOCS directory on Example42 main modules set.


## USAGE - Module specific settings

* Define one or more NTP Servers to use (Default value is an array of 4 servers from 'pool.ntp.org')

        class { 'ntp':
          server => [ '10.42.112.123' , '10.42.113.123' ],
        }

* Define NTP sync approach: Via NTP service (default) or via a ntpdate hourly cron job (with 600 secs random delay) (this example):

        class { 'ntp':
          runmode => 'cron',
        }

* Run ntp via cron with a custom command (default: ntpd -q). For example to use the 'old' ntpdate command and force clock sync:

        class { 'ntp':
          runmode      => 'cron',
          cron_command => 'ntpdate 0.pool.ntp.org && clock -w',
        }

## USAGE - Basic management

* Install ntp with default settings

        class { 'ntp': }

* Install a specific version of ntp package

        class { 'ntp':
          version => '1.0.1',
        }

* Disable ntp service.

        class { 'ntp':
          disable => true
        }

* Remove ntp package

        class { 'ntp':
          absent => true
        }

* Enable auditing without without making changes on existing ntp configuration files

        class { 'ntp':
          audit_only => true
        }


## USAGE - Overrides and Customizations
* Use custom sources for main config file 

        class { 'ntp':
          source   => [ "puppet:///modules/lab42/ntp/ntp.conf-${hostname}" , "puppet:///modules/lab42/ntp/ntp.conf" ], 
          template => '',    # This is needed because by default a template is used
        }


* Use custom source directory for the whole configuration dir

        class { 'ntp':
          source_dir       => 'puppet:///modules/lab42/ntp/conf/',
          source_dir_purge => false, # Set to true to purge any existing file not present in $source_dir
        }

* Use custom template for main config file. Note that template and source arguments are alternative. 

        class { 'ntp':
          template => 'example42/ntp/ntp.conf.erb',
        }

* Automatically include a custom subclass

        class { 'ntp':
          my_class => 'ntp::example42',
        }


## USAGE - Example42 extensions management 
* Activate puppi (recommended, but disabled by default)

        class { 'ntp':
          puppi    => true,
        }

* Activate puppi and use a custom puppi_helper template (to be provided separately with a puppi::helper define ) to customize the output of puppi commands 

        class { 'ntp':
          puppi        => true,
          puppi_helper => 'myhelper', 
        }

* Activate automatic monitoring (recommended, but disabled by default). This option requires the usage of Example42 monitor and relevant monitor tools modules

        class { 'ntp':
          monitor      => true,
          monitor_tool => [ 'nagios' , 'monit' , 'munin' ],
        }

* Activate automatic firewalling. This option requires the usage of Example42 firewall and relevant firewall tools modules

        class { 'ntp':       
          firewall      => true,
          firewall_tool => 'iptables',
          firewall_src  => '10.42.0.0/24',
          firewall_dst  => $ipaddress_eth0,
        }


[![Build Status](https://travis-ci.org/example42/puppet-ntp.png?branch=master)](https://travis-ci.org/example42/puppet-ntp)
