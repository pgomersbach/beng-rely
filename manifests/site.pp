# Default configuration BenG lab
# remarked out $create_users=false
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
    $tcp_9300_source1 = '172.19.53.0/24'
    $tcp_9300_source2 = false
    $tcp_9300_source3 = false
  }
  # LABS TEST
  /^lt[ea]s[12]/ : {
    notice ( "Firewall: ${hostname} - Applying 'test' rules for 9300-9400" )
    $tcp_9300_source1 = '172.19.60.0/24'
    $tcp_9300_source2 = false
    $tcp_9300_source3 = false
  }
  # LABS DEVEL
  'ldes1' : {
    notice ( "Firewall: ${hostname} - Applying 'devel' rules for 9300-9400" )
    $tcp_9300_source1 = '172.18.0.0/16'
    $tcp_9300_source2 = '172.19.0.0/16'
    $tcp_9300_source3 = '178.249.248.128/25'
  }
 'mws1' : {
    notice ( "Firewall: ${hostname} - Applying 'beta' rules for 9300-9400" )
    $tcp_9300_source1 = '172.19.53.0/24'
    $tcp_9300_source2 = false
    $tcp_9300_source3 = false
  }
  default: {
    $tcp_9300_source1 = false
    $tcp_9300_source2 = false
    $tcp_9300_source3 = false
  }
}

# Default and extra tcp ports
case $hostname {
  /^(ltas1|lbas[123]|mws1)/ : {
    notice ( "Firewall: ${hostname} - Applying 'extra tcp ports ('18061 and 8161')' rule." )
    $tcp_ports_global = [ '21','22','80','443','445','1556','5666','8000','8161','9100','9200','13720','13724','18086' ]    # call A1601 692 m1710 1445
  }
 /^(ltes1|lbes3)/ : {
    notice ( "Firewall: ${hostname} - Applying 'extra tcp port  ('3306')' rule at ltes1 and lbes3 ." )
    $tcp_ports_global = [ '21','22','80','443','445','1556','3306','5666','8000','9100','9200','13720','13724' ]    # call m1711 960
  }
  default: {
    notice ( "Firewall: ${hostname} - Using default tcp_ports rule." )
    $tcp_ports_global = [ '21','22','80','443','445','1556','5666','8000','9100','9200','13720','13724' ]
  }
}
# Extra ports B
case $hostname {
  # LABS TEST
  /^(ltas1|lbas2)/ : {
    	 notice ( "Firewall: ${hostname} - Applying ' RangeB tcp ports ('8080-8100')' rule." )
	$tcp_rangeB = '8080-8100'     # Extra ports (8080-8087) added,
                                  # added 8088,8089 and 8090 to expand range topdesk call 1411 1218
                                  # added port 8091
                                  # added port 8092, call 1509 251
				  # added port 8093 call m1605 257
				  # added port 8094-8095 call m1610 1393
				  # added port in range to extend to 8096 m1707 919
				  # added port in range to extend to 8097 m1711 1003
				  # added ports in range to extend to 8100 m1802 xxxx

  }

  /^lbas1/ : {
    	 notice ( "Firewall: ${hostname} - Applying ' RangeB tcp ports ('8080-8095')' rule." )
	$tcp_rangeB = '8080-8095'     # Extra ports (8080-8087) added,
                                  # added 8088,9089 and 8090 to expand range topdesk call 1411 1218
                                  # added port 8091
                                  # added port 8092, call 1509 251
				  # added port 8093 call m1606 067
				  # added port 8094-8095 call m1610 1393
  }
  default: {
    	 notice ( "Firewall: ${hostname} - Applying ' RangeB tcp ports ('8080-8090')' rule." )
	$tcp_rangeB = '8080-8090'     # Extra ports (8080-8087) added,
                                  # added 8088,9089 and 8090 to expand range topdesk call 1411 1218
  }
}
# Extra Ports C
case $hostname {
  default: {
    $tcp_rangeC = '8011-8015'     # Extra ports (8013-8015) added, consolidated with 8011 and 8012 as one range
  }
}
# Enable firewall
class { 'beng_fw' :
  tcp_public_ports => $tcp_public_ports,
  tcp_ports_global => $tcp_ports_global,
  tcp_extra_rule1  => $tcp_extra_rule1,
  tcp_rangeA_src1  => $tcp_9300_source1,
  tcp_rangeA_src2  => $tcp_9300_source2,
  tcp_rangeA_src3  => $tcp_9300_source3,
  tcp_rangeB       => $tcp_rangeB,
  tcp_rangeC       => $tcp_rangeC,
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
class { 'beng_nrpe': 
notice ( "NRPE: Checking/ Applying needed config files." )
}
# setup snmp
class { 'snmp':
  agentaddress => [ 'udp:161', ],
  ro_community => 'public',
  ro_network   => '172.19.53.17',
  contact      => 'servicedesk@beeldengeluid.nl',
  location     => 'Beeld en Geluid',
}
# Install vmware tools
class { '::vmwaretools':
  timesync => false,
# version is VMwareTools-<version.build number>.tar  aka VMwareTools-10.1.7-5541682.tar
#  version  => '10.0.9-3917699',
# actual version is 10.1.7.61298 (build-5541682)
  version => '10.1.7.61298',
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
# set invidual host password creation enabled
case $hostname {
 /^(deploy5)/ : {
    notice ( "Password: ${hostname} - Applying rule." )
	$create_users=true    
  }
/^(dev[wae]s2001)/ : {
    notice ( "Password: ${hostname} - Applying rule." )
	$create_users2001=true    
  }
  default: {
    notice ( "Password: ${hostname} - Not applying Passwords." )
 	 $create_users=false 
	}
}
# creat the actual users
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
if $create_useris2001 == true {
# Create default users
  user { 'appbeheer2001':
    ensure     => present,
    password   => '$6$GJ2gWWKE$viMcJ37nL1gHqLroZKBt.T6Sb2xvkVsDXTBYqSSiZDH3FGv5FX01YKnvUFqQjvGSM843/s92GcSu90aEQLEFq1',
    groups     => 'wheel',
    managehome => true,
    require    => Group['wheel'],
  }
  user { 'deploy2001':
    ensure     => present,
    password   => '$6$TcjVG0JT$6rW9JAxlgtxZgMq9XrWFuKEktPZ4N5cru1cRiU585PhajHwLtyBvaMRqsCBsgJyOAKdFeM/E0O0aZiNkX2yv10',
    groups     => 'wheel',
    managehome => true,
    require    => Group['wheel'],
  }
  user { 'systeembeheer2001':
    ensure     => present,
    password   => '$6$EoJD7C5n$dF91rI2qEL/CtPMGompYnI5vwxRXa1w.CO3A9.n5voPwBT67kzOkBsKQcA0T7JGy.OPXcit/NxzObhfkI8na/0',
    groups     => 'wheel',
    managehome => true,
    require    => Group['wheel'],
  }
}
