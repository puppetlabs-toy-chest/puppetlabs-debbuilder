class debbuilder::setup::cows($cows = [
      "lucid",
      "squeeze",
      "natty",
      "oneiric",
      "precise",
      "quantal",
      "sid",
      "stable",
      "testing",
    ],
    $cow_root = '/var/cache/pbuilder',
    $pe = false) {

  case $pe {
      false:    { $cow_depends = [File[$cow_root], File["puppetlabs-keyring.gpg"], File["pbuilderrc"], Package["debian-keyring"], Package["debian-archive-keyring"], File["ubuntu-archive-keyring.gpg"], File["ubuntu-archive-removed-keys.gpg"], File["ubuntu-master-keyring.gpg"]] }
      true:     { $cow_depends = [File[$cow_root], File["puppetlabs-keyring.gpg"], File["pbuilderrc"], Package["debian-keyring"], Package["debian-archive-keyring"], File["ubuntu-archive-keyring.gpg"], File["ubuntu-archive-removed-keys.gpg"], File["ubuntu-master-keyring.gpg"], File["pluto-build-keyring.gpg"]] }
      default:  { fail("\$pe must be set to true or false.") }
  }

  debbuilder::setup::cow_exec { $cows:
    cow_root    => $cow_root,
    require     => $cow_depends,
  }

  debbuilder::setup::keyring { "puppetlabs-keyring.gpg": }

  file { $cow_root:
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => 0755,
    require => Exec[$cow_root],
  }

  exec { $cow_root:
    command   => "/bin/mkdir -p '${cow_root}'",
    user      => root,
    path      => "/usr/bin:/bin",
    unless    => "test -d '${cow_root}'",
  }

  file { "pbuilderrc":
    path      => "/etc/pbuilderrc",
    ensure    => file,
    content   => template("debbuilder/pbuilderrc.erb"),
    owner     => root,
    group     => root,
    mode      => 0644,
    require   => [Package["cowbuilder"], Package["pbuilder"]],
  }

  # The ubuntu-keyring isn't currently packaged for debian. Until that changes,
  # it is being added as four file resources
  debbuilder::setup::keyring { ["ubuntu-archive-keyring.gpg", "ubuntu-archive-removed-keys.gpg", "ubuntu-master-keyring.gpg"]: }

  if $pe {
    debbuilder::setup::keyring { "pluto-build-keyring.gpg": }
  }
}
