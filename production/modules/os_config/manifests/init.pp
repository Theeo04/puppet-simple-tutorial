# Here include all the configurations nad based on a 'puppet-fact' we decide which config to use:

class os_config {
  case $facts['os']['family'] {
    'Debian' : {
      include os_config::os::ubuntu_config   
    }

    'RedHat' : { 
      include os_config::os::redhat_config
    }

    'default' : { 
      include os_config::os::default_config
    }
  }
}
