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
    ],) {

  debbuilder::setup::cow_exec { $cows:
    cow_root    => '/var/cache/pbuilder',
    require     => [File["puppetlabs-keyring.gpg"], File["pbuilderrc"], Package["debian-keyring"], Package["debian-archive-keyring"], Package["ubuntu-keyring"]],
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
}
