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
      false:    { $cow_depends = [File["puppetlabs-keyring.gpg"], File["pbuilderrc"], Package["debian-keyring"], Package["debian-archive-keyring"], Package["ubuntu-keyring"]] }
      true:     { $cow_depends = [File["puppetlabs-keyring.gpg"], File["pbuilderrc"], Package["debian-keyring"], Package["debian-archive-keyring"], Package["ubuntu-keyring"], File["pluto-build-keyring.gpg"]] }
      default:  { fail("\$pe must be set to true or false.") }
  }

  debbuilder::setup::cow_exec { $cows:
    cow_root    => $cow_root,
    require     => $cow_depends,
  }

  file { "puppetlabs-keyring.gpg":
    path      => "/usr/share/keyrings/puppetlabs-keyring.gpg",
    ensure    => file,
    source    => "puppet:///modules/debbuilder/puppetlabs-keyring.gpg",
    owner     => root,
    group     => root,
    mode      => 0644,
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

  if $pe {
    file { "pluto-build-keyring.gpg":
      path      => "/usr/share/keyrings/pluto-build-keyring.gpg",
      ensure    => file,
      source    => "puppet:///modules/debbuilder/pluto-build-keyring.gpg",
      owner     => root,
      group     => root,
      mode      => 0644,
    }
  }
}
