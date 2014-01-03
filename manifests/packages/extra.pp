# This class brings in all of the packages that are needed to build packages
# using pbuilder or pdebuild. It also includes bash-completion, which is
# helpful when dealing with cowbuilder on the command line.  The debian keyring
# packages are needed for bootstrapping the cows during setup.

class debbuilder::packages::extra (
  $pe = false
){

  $extra_packages = [
    'bash-completion',
    'cowbuilder',
    'cowdancer',
    'debian-archive-keyring',
    'debian-keyring',
    'lintian',
    'pbuilder',
    'git-buildpackage',
    'libparse-debianchangelog-perl',
  ]

  package { $extra_packages: ensure => present, }

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

    package { 'cowsay':
      ensure => present,
    }
  }
}
