class beng_fw {
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
