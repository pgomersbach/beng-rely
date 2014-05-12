class beng_fw::prev4 (
  $internal_netA = '172.18.0.0/16',
  $internal_netB = '172.19.0.0/16',
  $internal_netC = '178.249.248.128/25',
  $tcp_ports = [ '20','21','22','53','80','123','443','445','1556','5666','8000','9100','9200','13720','13724'],
  $tcp_public_ports = $beng_fw::tcp_public_ports,
  $tcp_rangeA = '9300-9400',
  $tcp_rangeB = '8080-8082',

  $udp_ports = [ '53','123','161'],
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
  # Check if public ports should be allowed
  if $tcp_public_ports != false {
      firewall { '003 accept all TCP':
      dport    => $tcp_public_ports,
      proto    => 'tcp',
      action   => 'accept',
      provider => 'iptables',
    }
  }
  firewall { '010 allow internal netA TCP':
    dport    => $tcp_ports,
    proto    => 'tcp',
    source   => $internal_netA,
    action   => 'accept',
    provider => 'iptables',
  }
  firewall { '011 allow internal netB TCP':
    dport    => $tcp_ports,
    proto    => 'tcp',
    source   => $internal_netB,
    action   => 'accept',
    provider => 'iptables',
    }
  firewall { '012 allow internal netC TCP':
    dport    => $tcp_ports,
    proto    => 'tcp',
    source   => $internal_netC,
    action   => 'accept',
    provider => 'iptables',
  }
  firewall { '015 allow internal netA TCP range':
    dport    => $tcp_rangeA,
    proto    => 'tcp',
    source   => $internal_netA,
    action   => 'accept',
    provider => 'iptables',
  }
  firewall { '016 allow internal netB TCP range':
    dport    => $tcp_rangeA,
    proto    => 'tcp',
    source   => $internal_netB,
    action   => 'accept',
    provider => 'iptables',
    }
  firewall { '017 allow internal netC TCP range':
    dport    => $tcp_rangeA,
    proto    => 'tcp',
    source   => $internal_netC,
    action   => 'accept',
    provider => 'iptables',
    }
  firewall { '025 allow internal netA TCP rangeB':
    dport    => $tcp_rangeB,
    proto    => 'tcp',
    source   => $internal_netA,
    action   => 'accept',
    provider => 'iptables',
  }
  firewall { '026 allow internal netB TCP rangeB':
    dport    => $tcp_rangeB,
    proto    => 'tcp',
    source   => $internal_netB,
    action   => 'accept',
    provider => 'iptables',
    }
  firewall { '027 allow internal netC TCP rangeB':
    dport    => $tcp_rangeB,
    proto    => 'tcp',
    source   => $internal_netC,
    action   => 'accept',
    provider => 'iptables',
    }
  # UDP rules
  firewall { '020 allow internal netA UDP':
    dport    => $udp_ports,
    proto    => 'udp',
    source   => $internal_netA,
    action   => 'accept',
    provider => 'iptables',
  }
  firewall { '021 allow internal netB UDP':
    dport    => $udp_ports,
    proto    => 'udp',
    source   => $internal_netB,
    action   => 'accept',
    provider => 'iptables',
    }
  firewall { '022 allow internal netC UDP':
    dport    => $udp_ports,
    proto    => 'udp',
    source   => $internal_netC,
    action   => 'accept',
    provider => 'iptables',
  }

}
