class debbuilder::setup::pe {
  file { "pluto-build-keyring.gpg":
    path      => "/usr/share/keyrings/pluto-build-keyring.gpg",
    ensure    => file,
    source    => "puppet:///modules/debbuilder/pluto-build-keyring.gpg",
    owner     => root,
    group     => root,
    mode      => 0644,
  }
}
