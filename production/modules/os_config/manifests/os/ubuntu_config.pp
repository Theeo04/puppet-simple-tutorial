# Configuration file for Ubuntu OS -> based on FACTS

class os_config::os::ubuntu_config {
  package { 'curl':
    ensure => installed,
  }

  file { '/etc/motd':
    ensure  => file,
    content => "Welcome to Ubuntu - Hello from Puppet Server!\n",
  }

  # For firewall

  package { 'ufw': 
    ensure => installed,
  }

  service { 'ufw':
    ensure => running,
    enable => true,
    require => Package['ufw'],
  }

  # Allow SSH (port 22) and Puppet (port 8140) through the firewall
  exec { 'ufw allow ssh':
    command => '/usr/sbin/ufw allow 22',
    path    => ['/usr/bin', '/usr/sbin'],
    unless  => '/usr/sbin/ufw status | grep -q "22.*ALLOW"',
    require => Service['ufw'],
  }

  # Permit Puppet (port 8140)
  exec { 'ufw allow puppet':
    command => '/usr/sbin/ufw allow 8140',
    path    => ['/usr/bin', '/usr/sbin'],
    unless  => '/usr/sbin/ufw status | grep -q "8140.*ALLOW"',
    require => Service['ufw'],
  }
}
