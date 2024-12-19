# Here we use the 'config.pp' file and ensure the installation of the package + start of the service

class nginx {
  
  # Include all the configurations
  include nginx::config

  # Installation of the package
  package { 'nginx':
    ensure => installed,
  }

  # Ensure that the service is running
  service { 'nginx':
    ensure => running,
    enable => true,
    require => Package['nginx'],
  }
}
