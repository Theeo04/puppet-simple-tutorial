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

# Proiect: Creare 2 VM-uri `puppet-master` si `puppet-agent` pentru a configura Puppet

***! Note !:*** Nu am folosit `hiera.yaml` pentru ca am utilizat module create de la 0 => deci nu a fost nevoie de modificarea altor parametri 😁

#### 1. Creare si configurare VM-uri cu Multipass:

 - Instalare Multipass: `sudo apt install multipass`
 - Creare instante:
   - *puppet-master*: `multipass launch --name puppet-master --mem 3G --disk 11G --cpus 3`
   - *puppet-agent*: `multipass launch --name puppet-master --mem 2G --disk 10G --cpus 2`
 - Afisare VM-uri: `multipass list`
 - Conectare pe VM-uri: `multipass shell <nume-VM>`

#### Instalare si configurare Puppet:

Pe ambele vom rula script-ul:

```shell
sudo -i
apt update
wget https://apt.puppet.com/puppet8-release-focal.deb
dpkg -i puppet8-release-focal.deb
apt update
```
Iar pentru:
 - `master` vom avea de adaugat:

```shell
sudo apt install puppetserver
sudo systemctl start puppetserver
sudo systemctl enable puppetserver
```

 - `agent`:

```shell
sudo apt install puppet-agent
sudo systemctl start puppet.service
sudo systemctl enable puppet.service
```

Pentru a se punea recunoaste in baza DNS-ului:

 - Pentru `master` (in cazul in care ati numit masina `puppet-master`):

Pentru `/etc/hosts`

```shell
127.0.1.1 puppet-master puppet
127.0.0.1 localhost

# The following lines are desirable for IPv6 capable hosts
::1 localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
```

Pentru `/etc/puppetlabs/puppet/puppet.conf`

```shell
[server]
vardir = /opt/puppetlabs/server/data/puppetserver
logdir = /var/log/puppetlabs/puppetserver
rundir = /var/run/puppetlabs/puppetserver
pidfile = /var/run/puppetlabs/puppetserver/puppetserver.pid
codedir = /etc/puppetlabs/code

[main]
certname = puppet-master
dns_alt_names = puppet,puppet-master
environment = production
server = puppet-master
```

 - Pentru `agent` (in cazul in care ati numit masina `puppet-agent`):

 Pentru `/etc/hosts`:

```shell
127.0.1.1 puppet-agent puppet-agent
127.0.0.1 localhost
10.6.84.205 puppet puppet-master

# The following lines are desirable for IPv6 capable hosts
::1 localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters

```

Pentru `/etc/puppetlabs/puppet/puppet.conf`

```shell
[main]
certname = puppet-agent
server = puppet-master
environment = production

[server]
vardir = /opt/puppetlabs/server/data/puppetserver
logdir = /var/log/puppetlabs/puppetserver
rundir = /var/run/puppetlabs/puppetserver
pidfile = /var/run/puppetlabs/puppetserver/puppetserver.pid
codedir = /etc/puppetlabs/code
```

#### Acceptarea de certificate:

 - De pe `agent`: `sudo puppet agent -t`
 - Iar de pe `master`:
   - prima data pentru a vedea toate certificatele: `sudo puppetserver ca list --all`
   - pentru a permite comunicarea master-ului cu agent-ul: `sudo puppetserver ca sign --certname puppet-agent`

***Note:*** - este importanta respectarea fisierelor in ierarhia corecta + prezenta fisierelor de tip `metadata` configurate lamodul general!