class cpanm::install::rhel {
  # install cpanm the hard way b/c RHEL doesn't have a package for this
  ensure_packages(['perl'])

  if ! defined(Package['gcc']) {
    package { 'gcc':
        ensure => installed,
    }
  }

  # BELOW ONLY WORKS WITH BASH/SH, AND NOT ZSH
  # Set the path for cpanm
  file { '/etc/profile.d/cpanm.sh':
      mode    => 644,
      content => "PATH=/usr/local/sbin/:/usr/local/bin/:\$PATH",
  }
  -> 
  # Have it take effect
  exec { "source /etc/profile.d/cpanm.sh":
      provider => shell,
  }


  exec {"install_cpanm_for_RHEL":
    # puppet seems to change the current user weirdly when using the
    # user/group options. That causes cpanm to use /root/.cpanm for it's
    # temporary storage, which happens to not be writable for the perlbrew
    # user. Use /bin/su to work this around.
    # also added the -f option to force a reinstall of cpanm in case something is broken
    command => "/bin/su - -c 'umask 022; wget -O- http://cpanmin.us | /usr/bin/perl - App::cpanminus -f'",
    creates => "${::perl_installsitebin}/cpanm",
    require => Package["perl"],
  }

  # http://docs.puppetlabs.com/puppet/2.7/reference/lang_relationships.html
  Exec["install_cpanm_for_RHEL"] -> Package<| provider == cpanm |>

}

