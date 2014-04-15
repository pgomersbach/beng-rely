# Default configuration
class { '::ntp':
  servers => [ '172.18.99.210', '172.18.99.211' ],
}

user { 'appbeheer':
  ensure => present,
}
