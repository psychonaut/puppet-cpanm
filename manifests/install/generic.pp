class cpanm::install::generic {
  if ! defined(Package['cpanminus'])  { package { 'cpanminus': ensure => installed } }
  if ! defined(Package['perl-doc'])   { package { 'perl-doc':  ensure => installed } }
}
