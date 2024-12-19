# Mentionam nodurile si ce configurare sa fie pe respectivul nod
# Nodul trebuie să fie identificat prin numele său certificat (certname). node default { } -> pentru toate nodurile

# node 'puppet-agent' {
#   include nginx
# }

node default {
  include os_config
}
