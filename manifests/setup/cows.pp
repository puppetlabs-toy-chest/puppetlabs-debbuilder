# This class does the heavy lifting in setting up the cows. It instantiates a
# cow_exec for each of the cows, lays down needed keyrings to build up the cows
# correctly, and lays down the customized pbuilderrc file to add the correct
# repos to the cows.
# It also lays down some needed debootstrap scripts that may not be there on
# older versions of debian and ubuntu.  pluto-build-keyring is an internal
# build keyring used when $pe is set to true to correctly verify the signature
# of internal package repos.
# It can take three parameters, $cows, $cow_root, and $pe. $cows customizes the
# cows to build, $cow_root customizes the basedir from which to build the cows,
# and $pe is a boolean that customizes the cows for Puppet Labs internal
# builds.

class debbuilder::setup::cows (
  $cows = [
    "lucid",
    "squeeze",
    "natty",
    "oneiric",
    "precise",
    "quantal",
    "sid",
    "stable",
    "testing",
    "unstable",
    "wheezy",
  ],
  $cow_root = '/var/cache/pbuilder',
  $pe = false) {

  case $pe {
      false:    { $cow_depends = [
          File[$cow_root],
          File["puppetlabs-keyring.gpg"],
          File["pbuilderrc"],
          Package["debian-keyring"],
          Package["debian-archive-keyring"],
          File["ubuntu-archive-keyring.gpg"],
          File["ubuntu-archive-removed-keys.gpg"],
          File["ubuntu-master-keyring.gpg"]
        ]
      }
      true:     { $cow_depends = [
          File[$cow_root],
          File["puppetlabs-keyring.gpg"],
          File["pbuilderrc"],
          Package["debian-keyring"],
          Package["debian-archive-keyring"],
          File["ubuntu-archive-keyring.gpg"],
          File["ubuntu-archive-removed-keys.gpg"],
          File["ubuntu-master-keyring.gpg"],
          File["pluto-build-keyring.gpg"]
        ]
      }
      default:  { fail("\$pe must be set to true or false.") }
  }

  debbuilder::setup::cow_exec { $cows:
    cow_root    => $cow_root,
    require     => $cow_depends,
  }

  debbuilder::util::file_on_disk { "puppetlabs-keyring.gpg":
    source    => "puppet:///modules/debbuilder/",
    target    => "/usr/share/keyrings/",
  }

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
  # it is being added as three file resources
  debbuilder::util::file_on_disk { ["ubuntu-archive-keyring.gpg", "ubuntu-archive-removed-keys.gpg", "ubuntu-master-keyring.gpg"]:
    source    => "puppet:///modules/debbuilder/",
    target    => "/usr/share/keyrings/",
  }

  # Earlier debian and ubuntu versions won't have the scripts for newers versions for debootstrap
  debbuilder::util::file_on_disk { ["oneiric", "precise", "quantal", "wheezy"]:
    source    => "puppet:///modules/debbuilder/",
    target    => "/usr/share/debootstrap/scripts/",
    require   => Package["cowbuilder"],
  }

  # If $pe is true, lay down the pluto-build-keyring to correctly
  # validate the package repos.
  if $pe {
    debbuilder::util::file_on_disk { "pluto-build-keyring.gpg":
      source    => "puppet:///modules/debbuilder/",
      target    => "/usr/share/keyrings/",
    }
  }
}
