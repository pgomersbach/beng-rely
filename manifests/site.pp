# Default configuration

group { 'wheel': ensure => present, }

augeas { "sudowheel":
  context => "/files/etc/sudoers",
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

user { 'appbeheer':
  ensure => present,
}

user { 'deploy':
  ensure => present,
}

user { 'systeembeheer':
  ensure => present,
}

