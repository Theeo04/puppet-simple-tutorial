# Puppet Tutorial

Puppet este o platformă de automatizare a infrastructurii IT și de management al configurației. Este utilizată pentru a automatiza procesul de gestionare, configurare și implementare a infrastructurii IT, inclusiv servere, aplicații, rețele și alte componente ale unui mediu IT.

Caracteristici principale ale Puppet:

- **Limbaj declarativ**
- **Model client-server**: Puppet funcționează pe baza unui model Master-Agent:
    - Puppet Master: Serverul central care deține configurațiile și gestionează implementarea lor.
    - Puppet Agent: Componenta instalată pe mașinile client care primește și aplică configurațiile de la Puppet Master.
- **Cross-platform**: Puppet poate gestiona infrastructuri pe diverse sisteme de operare, inclusiv Linux, Windows, macOS și alte platforme.
- **Idempotent**: Puppet este idempotent, ceea ce înseamnă că aplicarea configurațiilor de mai multe ori nu schimbă nimic dacă starea dorită este deja atinsă.

## Resurse Importante:

 - Arhitecture
 - DSL Puppet Language
 - Puppet Classes
 - Manifests
 - Nodes


### 1. Arhitectura

Arhitectura Puppet este bazată pe un model client-server și implică mai multe componente care lucrează împreună pentru a gestiona și automatiza configurarea infrastructurii.

1. **Puppet Master (Server de control):** este componenta centrală care stochează și livrează configurațiile nodurilor.

2. **Puppet Agent (Client):** aplică configurațiile primite și raportează starea înapoi către Puppet Master.

3. **Resources Catalog:** este un fișier generat de Puppet Master care descrie starea dorită a unui nod si conține toate resursele pe care Puppet trebuie să le creeze, modifice sau gestioneze.

4. **Facter:** 
 - O componentă care colectează informații despre fiecare nod (sistem de operare, adrese IP, nume gazdă etc.).
 - Faptele sunt folosite de Puppet Master pentru a personaliza configurațiile.

5. **Hiera:**
 - Sistem de gestionare ierarhică a datelor.
 - Permite stocarea separată a variabilelor și valorilor pentru configurări.

6. **Certificare SSL (Securitate):** Puppet folosește SSL pentru a asigura comunicarea securizată între agenți și master.

#### Fluxul de lucru în arhitectura Puppet:
 - Agentul se conectează la Master
 - Master-ul compilează catalogul
 - Agentul aplică configurațiile
 - Raportarea stării

#### 2. DSL Puppet Language

**Exemple:**
1. Resurse:

```puppet
resource_type { 'resource_name':
  attribute1 => value1,
  attribute2 => value2,
}
```

```puppet
file { '/etc/motd':
  ensure  => 'present',
  content => "Welcome to Puppet!",
  mode    => '0644',
}
```

2. Variabile:

```puppet
$greeting = "Hello, Puppet!"
file { '/etc/motd':
  ensure  => 'file',
  content => $greeting,
}
```

### 3. Classes

Clasele sunt un concept fundamental în Puppet, folosit pentru a organiza, structura și reutiliza configurațiile.

**Exemplu:**

```puppet
class ntp {
  package { 'ntp':
    ensure => 'installed',
  }

  service { 'ntpd':
    ensure => 'running',
    enable => true,
  }
}
```

### 4. Manifests

Manifests sunt fișiere care conțin codul Puppet scris în DSL-ul său. Ele descriu starea dorită a resurselor din infrastructura si definesc ce configurări să fie aplicate nodurilor. Manifestele sunt scrise în fișiere cu extensia .pp (prescurtare de la Puppet Program).

**Localizarea manifestelor în Puppet:**
Manifestele sunt stocate în directorul: `/etc/puppetlabs/code/environments/production/manifests/`

*Exemple de fișiere comune:*
 - `site.pp`: Manifestul principal care conține configurația întregii infrastructuri.
 - Alte fișiere .pp pot fi organizate pe module sau funcționalități.