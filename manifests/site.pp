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
  ensure   => present,
  password => '$6$/9ib4x/n$92gZmU11nUPSZzI7sZ/7aroEhVRFiu8a1NXBouw6ljuClz6DkwCaEXOwpC6JWlvGKA7hh7C13kq94PcPh8Ds0',
}

user { 'deploy':
  ensure     => present,
  password   => '$6$XDXqfHBY$gTIaTau4Ic0awD2AVHTh4nP5QAShrItpqESFbN7bq6N2Kt/Alb34QQFDhQQbyy9pQgVpON5ZsqdZSPqTwZETZ',
  groups     => 'wheel',
  managehome => true,
}

user { 'systeembeheer':
  ensure   => present,
  password => '$6$/9ib4x/n$92gZmU11nUPSZzI7sZ/7aroEhVRFiu8a1NXBouw6ljuClz6DkwCaEXOwpC6JWlvGKA7hh7C13kq94PcPh8Ds0',
}

