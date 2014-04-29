# Default configuration
include beng_fw
group { 'wheel': ensure => present, }

augeas { 'sudowheel':
  context => '/files/etc/sudoers',
  changes => [
    "set spec[user = '%wheel']/user %wheel",
    "set spec[user = '%wheel']/host_group/host ALL",
    "set spec[user = '%wheel']/host_group/command ALL",
    "set spec[user = '%wheel']/host_group/command/runas_user ALL",
    "set spec[user = '%wheel']/host_group/command/tag NOPASSWD",
    ],
}

file {'/etc/resolv.conf':
  source => '/etc/puppet/files/resolv.conf',
}

class { '::ntp':
  servers => [ '172.18.99.210', '172.18.99.211' ],
}

class { 'beng_nrpe': }

class { 'snmp':
  agentaddress => [ 'udp:161', ],
  ro_community => 'public',
  contact      => 'servicedesk@rely.nl',
  location     => 'Beeld en Geluid',
}

class { '::vmwaretools':
  timesync => false,
  version  => '9.4.0-1280544',
}

class { '::vsftpd':
  anonymous_enable   => 'NO',
  write_enable       => 'YES',
  ftpd_banner        => 'BenG FTP Server',
  chroot_local_user  => 'YES',
  chroot_list_enable => 'YES',
}

file { '/etc/vsftpd/chroot_list':
  content => 'root',
  require => Class['vsftpd'],
}

user { 'appbeheer':
  ensure     => present,
  password   => '$6$whFu5R20$VZYxY42iExf8nd8yDIwXz6.K9D68BsreDcBUi9mqjO02x.m6i1HuD/uuHViqHvbWh.19.jDoMcMKOo1rtNaja.',
  groups     => 'wheel',
  managehome => true,
  require    => Group['wheel'],
}

user { 'deploy':
  ensure     => present,
  password   => '$6$whFu5R20$VZYxY42iExf8nd8yDIwXz6.K9D68BsreDcBUi9mqjO02x.m6i1HuD/uuHViqHvbWh.19.jDoMcMKOo1rtNaja.',
  groups     => 'wheel',
  managehome => true,
  require    => Group['wheel'],
}

user { 'systeembeheer':
  ensure     => present,
  password   => '$6$whFu5R20$VZYxY42iExf8nd8yDIwXz6.K9D68BsreDcBUi9mqjO02x.m6i1HuD/uuHViqHvbWh.19.jDoMcMKOo1rtNaja.',
  groups     => 'wheel',
  managehome => true,
  require    => Group['wheel'],
}

