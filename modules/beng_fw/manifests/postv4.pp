class beng_fw::postv4 {
  firewall { '900 log all drop connections':
    proto      => 'all',
    jump       => 'LOG',
    limit      => '5/min',
    log_prefix => 'IPTables-Rejected: ',
    provider   => 'iptables',
  }->
  firewall { '950 drop udp':
    proto    => 'udp',
    reject   => 'icmp-port-unreachable',
    action   => 'reject',
    provider => 'iptables',
  }->
  firewall { '951 drop tcp':
    proto    => 'tcp',
    reject   => 'tcp-reset',
    action   => 'reject',
    provider => 'iptables',
  }->
  firewall { '952 drop icmp':
    proto    => 'icmp',
    action   => 'drop',
    provider => 'iptables',
  }->
  firewall { '999 drop everything else - this is the failsafe rule':
    proto    => 'all',
    action   => 'drop',
    provider => 'iptables',
    before   => undef,
  }
}
