# Here is the configuration for important files

class nginx::config {

  # Build the 'congifuration' file using a template:
  file { '/etc/nginx/nginx.conf' :
    ensure  => file,
    content => template('nginx/nginx.conf.erb'),
    require => Package['nginx'],
    notify  => Service['nginx'],
  }

  # Configure the directory for web pages
  file { '/var/www/html':
    ensure => directory,
    owner => 'www-data',
    group => 'www-data',
    mode  => '0775',
    require => Package['nginx'], 
  }

  # Configuration for 'index.html'
  file { '/var/www/html/index.html':
    ensure  => file,
    content => template('nginx/index.html.erb'),
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0644',
    require => Package['nginx'],
    notify  => Service['nginx'],
  }
}
