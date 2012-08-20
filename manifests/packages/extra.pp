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

  package { $extra_packages: ensure => present, }
}
