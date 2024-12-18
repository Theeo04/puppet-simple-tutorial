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
1. **Resurse:**

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

2. **Variabile:**

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

 **! NOTE !**: tot ceea ce Puppet aplică unui nod este descris într-un manifest(cele scise la punctele de mai sus). Fie că folosești resurse individuale, clase, definiții parametrizate sau chiar logică condițională, toate aceste elemente sunt scrise în manifestele Puppet.

---

#### Folosirea `::` in Puppet:

- Accesarea resurselor globale (Spațiu de nume global)
- Se folosește pentru a accesa variabile globale, clase și resurse definite în moduri explicite.

Exemplu:
```
classes:
  - popp_common::cassandra_datadir
```

Explicație detaliată:

  - classes:: Aceasta este o secțiune care se află într-un fișier de configurare Hiera sau într-un alt context unde se specifică clasele ce urmează a fi aplicate unui nod.
    - popp_common::cassandra_datadir: Acesta este numele complet al unei clase din modulul popp_common, iar cassandra_datadir este o clasă definită în acel modul.
        - popp_common: Este numele modulului în care este definită clasa.
        - `::`: Operatorul de namespace este folosit pentru a face referire la clasa cassandra_datadir din modulul popp_common. Acesta ajută la clarificarea că vrei să folosești exact acea clasă și nu o altă clasă cu același nume care ar putea fi definită într-un alt modul sau context.

#### Cum funcționează `define` în Puppet?

Când folosești define, poți crea resurse care sunt instanțiate doar atunci când le folosești cu parametrii specifici. Aceste resurse nu sunt evaluate automat la încărcarea manifestului, ci sunt evaluate atunci când sunt instanțiate efectiv.

**Exemplu:**

```puppet
define <nume_resursa>($parametru1, $parametru2, ...) {
  # Logică pentru resursă
  resource_type { $title:
    param1 => $parametru1,
    param2 => $parametru2,
  }
}
```

