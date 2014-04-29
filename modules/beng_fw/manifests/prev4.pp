class beng_fw::prev4 (
  $internal_nets = [ '172.18.0.0/16','172.19.0.0/16' ],
  $tcp_ports = [ '20','21','22','53','80','123','443','445','1556','5666','9100','9200','13720','13724'],
  $tcp_range = '9300:9400',
  $udp_ports = [ '53','123','161']
){
  Firewall {
    require => undef,
  }
  # Default firewall rules
  firewall { '000 accept all icmp':
    proto    => 'icmp',
    action   => 'accept',
    provider => 'iptables',
  }
  firewall { '001 accept all to lo interface':
    proto    => 'all',
    iniface  => 'lo',
    action   => 'accept',
    provider => 'iptables',
  }
  firewall { '002 accept related established rules':
    proto    => 'all',
    state    => ['RELATED', 'ESTABLISHED'],
    action   => 'accept',
    provider => 'iptables',
  }
  firewall { '010 allow internal networks TCP':
  #  dport    => ${tcp_ports},
    dport => [ '20','21','22','53','80','123','443','445','1556','5666','9100','9200','13720','13724'],
    proto    => 'tcp',
#    source   => ${internal_nets},
    source => [ '172.18.0.0/16','172.19.0.0/16' ],
    action   => 'accept',
    provider => 'iptables',
  }
  firewall { '015 allow internal networks TCP range':
#    dst_range => ${tcp_range},
    dport => '9300-9400',
    proto    => 'tcp',
#    source   => ${internal_nets},
    source => [ '172.18.0.0/16','172.19.0.0/16' ],
    action   => 'accept',
    provider => 'iptables',
  }
  firewall { '020 allow internal networks UDP':
#    dport    => ${udp_ports},
    dport => [ '53','123','161'],
    proto    => 'udp',
#    source   => ${internal_nets},
    source => [ '172.18.0.0/16','172.19.0.0/16' ],
    action   => 'accept',
    provider => 'iptables',
  }
}
