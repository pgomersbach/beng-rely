class beng_fw {
  resources { "firewall":
    purge => true
  }
  Firewall {
    before  => Class['wufirewall::postv4'],
    require => Class['wufirewall::prev4'],
  }
  class { ['wufirewall::prev4', 'wufirewall::postv4']: }
  class { 'firewall': }
}
