#Install Beeld en Geluid nagios nrpe packages
#Install nrpe config
#Install local nrpe checks

class beng_nrpe (
  $baseurl='/etc/puppet/files/'
){
  $rpmurl="${baseurl}/nrpe-complied-rhel6/"
  $configurl="${baseurl}/nrpe.cfg"
  $checkurl="${baseurl}/local_commands.cfg"

  package { [ 'perl-Digest-HMAC', 'perl-Digest-SHA1']:
    ensure => installed,
  }->

  package { 'perl-Crypt-DES':
    ensure   => installed,
    provider => rpm,
    source   => "${rpmurl}/perl-Crypt-DES-2.05-9.el6.x86_64.rpm",
  }->

  package { 'perl-Net-SNMP':
    ensure   => installed,
    provider => rpm,
    source   => "${rpmurl}/perl-Net-SNMP-5.2.0-4.el6.noarch.rpm",
  }->

  package { 'vdl-nagios-common':
    ensure   => installed,
    provider => rpm,
    source   => "${rpmurl}/vdl-nagios-common-3.2-3.noarch.rpm",
  }->

  package { 'vdl-nagios-plugins':
    ensure   => installed,
    provider => rpm,
    source   => "${rpmurl}/vdl-nagios-plugins-1.4.15-2.x86_64.redhat.rpm",
  }->

  package { 'vdl-nrpe':
    ensure   => installed,
    provider => rpm,
    source   => "${rpmurl}/vdl-nrpe-2.12-4.x86_64.redhat.rpm",
  }->

  package { 'vdl-nrpe-plugin':
    ensure   => installed,
    provider => rpm,
    source   => "${rpmurl}/vdl-nrpe-plugin-2.12-4.x86_64.redhat.rpm",
  }->

  file {'/usr/local/nrpe/etc/bronze/local_commands.cfg':
    source => $checkurl,
    notify  => Service [ 'nrpe' ],
  }->
  file {'/usr/local/nrpe/etc/nrpe.cfg':
    source => $configurl,
    notify  => Service [ 'nrpe' ],
  }
 
  service { 'nrpe':
    ensure => running,
  }
}
