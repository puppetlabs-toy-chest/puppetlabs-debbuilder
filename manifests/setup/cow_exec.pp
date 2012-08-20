define debbuilder::setup::cow_exec( $cow_root = '/var/cache/pbuilder' ) {

  exec { "${name}-i386":
    path          => "/usr/sbin:/usr/bin:/bin:/sbin",
    command       => "cowbuilder --create --basepath=${cow_root}/base-${name}-i386.cow/ --debug",
    unless        => "test -e ${cow_root}/base-${name}-i386.cow",
    environment   => ["DIST=${name}", "ARCH=i386"],
    logoutput     => on_failure,
    user          => root,
    timeout       => 0,
  }

  exec { "${name}-amd64":
    path          => "/usr/sbin:/usr/bin:/bin:/sbin",
    command       => "cowbuilder --create --basepath=${cow_root}/base-${name}-amd64.cow/ --debug",
    unless        => "test -e ${cow_root}/base-${name}-amd64.cow",
    environment   => ["DIST=${name}", "ARCH=amd64"],
    logoutput     => on_failure,
    user          => root,
    timeout       => 0,
  }

  cron { "${name}-i386":
    command       => "cowbuilder --update --basepath=${cow_root}",
    environment   => "DIST=${name} ARCH=i386 PATH=/usr/sbin:/usr/bin:/bin:/sbin",
    hour          => "2",
    minute        => "15",
    name          => "cowbuilder update for ${name}-i386",
    user          => root,
  }

  cron { "${name}-amd64":
    command       => "cowbuilder --update --basepath=${cow_root}",
    environment   => "DIST=${name} ARCH=amd64 PATH=/usr/sbin:/usr/bin:/bin:/sbin",
    hour          => "2",
    minute        => "15",
    name          => "cowbuilder update for ${name}-amd64",
    user          => root,
  }

}
