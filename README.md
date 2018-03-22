# CPANMinus Package Provider for Puppet

This module provides a basic package provider for CPAN through the `cpanminus` binary.
It assumes `cpanminus` can be found at /usr/bin, currently, and provides a puppet class,
`cpanm`, which will install the `cpanminus` package, if needed/desired/available.

## Usage

    package { 'Moose': ensure => present, provider => cpanm }

    package { 'MooseX::App::Cmd': ensure => latest, provider => 'cpanm' }

## rpm package for CentOS7

Spec file for building rpm file: https://gist.github.com/psychonaut/3810976f2e024b90cae616b5521233ec

## License

Apache License, version 2.0

