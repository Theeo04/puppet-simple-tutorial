# Puppet Tutorial

Puppet este o platformă de automatizare a infrastructurii IT și de management al configurației. Este utilizată pentru a automatiza procesul de gestionare, configurare și implementare a infrastructurii IT, inclusiv servere, aplicații, rețele și alte componente ale unui mediu IT.

Caracteristici principale ale Puppet:

- Limbaj declarativ
- Model client-server: Puppet funcționează pe baza unui model Master-Agent:
    - Puppet Master: Serverul central care deține configurațiile și gestionează implementarea lor.
    - Puppet Agent: Componenta instalată pe mașinile client care primește și aplică configurațiile de la Puppet Master.
- Cross-platform: Puppet poate gestiona infrastructuri pe diverse sisteme de operare, inclusiv Linux, Windows, macOS și alte platforme.
- Idempotent: Puppet este idempotent, ceea ce înseamnă că aplicarea configurațiilor de mai multe ori nu schimbă nimic dacă starea dorită este deja atinsă.

**Exemple de cod Puppet:** un exemplu simplu care instalează și asigură că serviciul Apache este pornit:
```puppet
class { 'apache':
  ensure => 'present',
}

service { 'apache2':
  ensure     => 'running',
  enable     => true,
  require    => Package['apache'],
}
```