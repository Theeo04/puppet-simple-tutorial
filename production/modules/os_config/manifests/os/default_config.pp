class os_config::os::default_config {
  file { '/etc/motd':
    ensure  => file,
    content => "This OS is unsupported (unconfigured server) - Hello from Puppet Server!\n",
  }
}

