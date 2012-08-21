define debbuilder::setup::file_on_disk (
  $source = "puppet:///modules/debbuilder/",
  $target = "/usr/share/",
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
