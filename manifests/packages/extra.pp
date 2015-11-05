# This class brings in all of the packages that are needed to build packages
# using pbuilder or pdebuild. It also includes bash-completion, which is
# helpful when dealing with cowbuilder on the command line.  The debian keyring
# packages are needed for bootstrapping the cows during setup.

class debbuilder::packages::extra (
  $pe = false,
  $ensure = present,
){

  $extra_packages = [
    'cowbuilder',
    'cowdancer',
    'debian-archive-keyring',
    'debian-keyring',
    'lintian',
    'pbuilder',
    'git-buildpackage',
    'libparse-debianchangelog-perl',
  ]

  if $debbuilder::manage_bashcompletion_package {
    package { 'bash-completion':
      ensure => $ensure,
    }
  }
  ensure_packages( $extra_packages, {
    ensure => $ensure,
  })

  if ($pe) {
    file { 'puppetlabs lintian profile directory':
      ensure  => directory,
      path    => '/usr/share/lintian/profiles/puppetlabs',
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      require => Package['lintian'],
    }

    file { 'main.profile':
      ensure  => present,
      source  => 'puppet:///modules/debbuilder/lintian-main.profile',
      path    => '/usr/share/lintian/profiles/puppetlabs/main.profile',
      mode    => '0644',
      require => File['puppetlabs lintian profile directory'],
    }

    ensure_packages( 'cowsay', {
      ensure => $ensure,
    })
  }

  include "gpg"
}
