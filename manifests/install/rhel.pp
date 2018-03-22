class cpanm::install::rhel {
  if ! defined(Package['perl-App-cpanminus'])  { package { 'perl-App-cpanminus': ensure => installed } }
}
