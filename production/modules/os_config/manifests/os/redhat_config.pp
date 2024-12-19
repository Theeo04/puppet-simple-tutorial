# Configuration file for RedHat OS -> based on FACTS

class os_config::os::redhat_config {
  package { 'curl':
    ensure => installed,
  }

  file { 'etc/motd':
    ensure  => file,
    content => "Welcome to Ubuntu - Hello from Puppet Server!\n",
  }

  # For firewall

  package{ 'firewalld':
    ensure => installed,
  }

  service { 'firewalld':
    ensure => running,
    enable => true,
    require => Package['firewalld']
  }

  # Allow SSH (port 22) and Puppet (port 8140) through the firewall
  firewalld_zone { 'public':
    ensure => present,
    zone   => 'public',
    state  => 'enabled',
  }

  # Allow port 22 for SSH
  firewalld_service { 'ssh':
    ensure => 'present',
    zone   => 'public',
  }

  # Allow port 8140 for Puppet
  firewalld_port { 'puppet':
    ensure => 'present',
    zone   => 'public',
    port   => '8140/tcp',
  }
}
