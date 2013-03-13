class cpanm::install {
  # this is all nice and good, but RHEL doesn't have these packages or anything for cpanminus
  #   if ! defined(Package['cpanminus'])  { package { 'cpanminus': ensure => installed } }
  #   if ! defined(Package['perl-doc'])   { package { 'perl-doc':  ensure => installed } }
  case $::operatingsystem {
    'RedHat': {include cpanm::install::rhel}
    default: {include cpanm::install::generic}
  }
}

