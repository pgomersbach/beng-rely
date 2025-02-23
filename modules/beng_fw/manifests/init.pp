class beng_fw (
    $tcp_public_ports = false,
	$tcp_ports_global = false,
    $tcp_extra_rule1 = false,
    $tcp_rangeA_src1 = false,
    $tcp_rangeA_src2 = false,
    $tcp_rangeA_src3 = false,
	$tcp_rangeB = false,
	$tcp_rangeC = false,
	$tcp_rangeD = false,
	$tcp_rangeE = false,
	
  ) {
  resources { 'firewall':
    purge => true
  }
  Firewall {
    before  => Class['beng_fw::postv4'],
    require => Class['beng_fw::prev4'],
  }
  class { ['beng_fw::prev4', 'beng_fw::postv4']: }
  class { 'firewall': }
}
