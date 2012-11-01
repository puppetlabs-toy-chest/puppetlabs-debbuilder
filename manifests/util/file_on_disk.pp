# Generic defined type that allows for mass laydown of similar files without
# code duplication. The source and target prefixes are customizable as long as
# the end of the path is the same as the title of the resource.

define debbuilder::util::file_on_disk (
  $source = 'puppet:///modules/debbuilder/',
  $target = '/usr/share/',
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
