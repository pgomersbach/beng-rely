# Default configuration BenG lab
$create_users=false

# Check if host is a public webserver
case $hostname {
  /^l[bt]ws[12]/ : {
    notice ( "Firewall: ${hostname} is a public server, opening outside ports" )
    $tcp_public_ports = [ '80','443' ]
  }
  default: {
    notice ( "Firewall: ${hostname} is a private server, leaving outside ports closed" )
    $tcp_public_ports = false
  }
}

# 9300-9400 source rule set
case $hostname {
  # LABS BETA
  /^lb[ea]s[123]/ : {
    notice ( "Firewall: ${hostname} - Applying 'beta' rules for 9300-9400" )
    $tcp_9300_source1 = '172.19.53.0/24',
    $tcp_9300_source2 = false,
    $tcp_9300_source3 = false,
  }
  # LABS TEST
  /^lt[ea]s[12]/ : {
    notice ( "Firewall: ${hostname} - Applying 'test' rules for 9300-9400" )
    $tcp_9300_source1 = '172.19.60.0/24',
    $tcp_9300_source2 = false,
    $tcp_9300_source3 = false,
  }
  # LABS DEVEL
  'ldes1' : {
    notice ( "Firewall: ${hostname} - Applying 'devel' rules for 9300-9400" )
    $tcp_9300_source1 = '172.18.0.0/16',
    $tcp_9300_source2 = '172.19.0.0/16',
    $tcp_9300_source3 = '178.249.248.128/25',
  }

  default: {
    $tcp_9300_source1 = false,
    $tcp_9300_source2 = false,
    $tcp_9300_source3 = false,
  }
}

# Enable firewall
class { 'beng_fw' :
  tcp_public_ports => $tcp_public_ports,
  tcp_extra_rule1  => $tcp_extra_rule1,
  tcp_rangeA_src1  = $tcp_9300_source1,
  tcp_rangeA_src2  = $tcp_9300_source2,
  tcp_rangeA_src3  = $tcp_9300_source3,
}

# Create group and enable sudo
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

# Resolv to BenG DNS servers
file {'/etc/resolv.conf':
  source => '/etc/puppet/files/resolv.conf',
}

# Enable network time protocol
class { '::ntp':
  servers => [ '172.18.99.210', '172.18.99.211' ],
}

# Add host to BenG Nagios monitoring
class { 'beng_nrpe': }

class { 'snmp':
  agentaddress => [ 'udp:161', ],
  ro_community => 'public',
  ro_network   => '172.19.53.17',
  contact      => 'servicedesk@rely.nl',
  location     => 'Beeld en Geluid',
}

# Install vmware tools
class { '::vmwaretools':
  timesync => false,
  version  => '9.4.0-1280544',
}

# Install vsftpd
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

if $create_users == true {
# Create default users
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
}

