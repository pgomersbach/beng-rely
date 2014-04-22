#Install Beeld en Geluid nagios nrpe packages
#Install nrpe config
#Install local nrpe checks

class beng_nrpe (
  $baseurl='http://s404.ka.beeldengeluid.nl/nagios/depot/lin'
){
  $rpmurl="$baseurl/nrpe-complied-rhel6/"
  $configurl="$baseurl/nrpe.cfg"
  $checkurl="$baseurl/bronze/local_commands.cfg"

  package { [ 'perl-Digest-HMAC', 'perl-Digest-SHA1']:
    ensure => installed,
  }->

  package { 'perl-Net-SNMP':
    provider => rpm,
    ensure   => installed,
    source   => "$rpmurl/perl-Net-SNMP-5.2.0-4.el6.noarch.rpm",
  }->

  package { 'perl-Crypt-DES':
    provider => rpm,
    ensure   => installed,
    source   => "$rpmurl/perl-Crypt-DES-2.05-9.el6.x86_64.rpm",
  }->

  package { 'vdl-nagios-common':
    provider => rpm,
    ensure   => installed,
    source   => "$rpmurl/vdl-nagios-common-3.2-3.noarch.rpm",
  }->
  
  package { 'vdl-nagios-plugins':
    provider => rpm,
    ensure   => installed,
    source   => "$rpmurl/vdl-nagios-plugins-1.4.15-2.x86_64.redhat.rpm",
  }->

  package { 'vdl-nrpe':
    provider => rpm,
    ensure   => installed,
    source   => "$rpmurl/vdl-nrpe-2.12-4.x86_64.redhat.rpm",
  }->

  package { 'vdl-nrpe-plugin':
    provider => rpm,
    ensure   => installed,
    source   => "$rpmurl/vdl-nrpe-plugin-2.12-4.x86_64.redhat.rpm",
  }->

  exec{ 'retrieve_checks':
    command => "/usr/bin/wget -q $checkurl -O /usr/local/nrpe/etc/bronze/local_commands.cfg",
    notify  => Service [ 'nrpe' ],
  }->

  exec{ 'retrieve_config':
    command => "/usr/bin/wget -q $configurl -O /usr/local/nrpe/etc/nrpe.cfg",
    notify  => Service [ 'nrpe' ],
  }

  service { 'nrpe':
    ensure => running,
  }
}
