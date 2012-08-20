define debbuilder::setup::keyring (
  $source = "puppet:///modules/debbuilder/",
  $target = "/usr/share/keyrings/",
) {
  file { $title:
    path      => "${target}/${title}",
    ensure    => file,
    source    => "${source}/${title}",
    owner     => root,
    group     => root,
    mode      => 0644,
  }
}
