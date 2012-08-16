class debbuilder::packages::extra {

  $extra_packages = [
    "pbuilder",
    "cowbuilder",
    "cowdancer",
    "debian-keyring",
    "debian-archive-keyring",
    "keychain",
    "gnupg",
    "bash-completion",
  ]

  package { $extra_packages: ensure => latest, }

  # The ubuntu-keyring isn't currently packaged for debian. Until that changes,
  # it is being included as a source file deb.

  package { "ubuntu-keyring":
    ensure    => present,
    provider  => 'dpkg',
    source    => 'puppet:///modules/debbuilder/ubuntu-keyring_2012.05.19_all.deb'
  }

}
