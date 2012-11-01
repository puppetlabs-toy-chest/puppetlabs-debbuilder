# This defined type takes one parameter, the cow_root where the cows will be
# built.  Building cows takes a long time, so both execs in this defined type
# have timeout set to 0. In my tests, each cow took between 5 and 10 minutes to
# complete. That totals to between 90 and 180 minutes for a default run. The
# defined type also lays down two cron jobs to maintain the cows, one for each.

define debbuilder::setup::cow_exec ( $cow_root = '/var/cache/pbuilder' ) {
  if ($::architecture == 'i386' or $::architecture == 'amd64') {
    exec { "${name}-i386":
      path          => '/usr/sbin:/usr/bin:/bin:/sbin',
      command       => "cowbuilder --create --basepath=${cow_root}/base-${title}-i386.cow/ --debug",
      unless        => "test -e ${cow_root}/base-${name}-i386.cow",
      environment   => ["DIST=${name}", 'ARCH=i386'],
      logoutput     => on_failure,
      user          => root,
      timeout       => 0,
    }

    cron { "${name}-i386":
      command       => "cowbuilder --update --basepath=${cow_root}",
      environment   => ["DIST=${name}", 'ARCH=i386', 'PATH=/usr/sbin:/usr/bin:/bin:/sbin'],
      hour          => '2',
      minute        => '15',
      name          => "cowbuilder update for ${name}-i386",
      user          => root,
    }
  }

  if ($::architecture == 'amd64') {
    exec { "${name}-amd64":
      path          => '/usr/sbin:/usr/bin:/bin:/sbin',
      command       => "cowbuilder --create --basepath=${cow_root}/base-${name}-amd64.cow/ --debug",
      unless        => "test -e ${cow_root}/base-${name}-amd64.cow",
      environment   => ["DIST=${name}", 'ARCH=amd64'],
      logoutput     => on_failure,
      user          => root,
      timeout       => 0,
    }

    cron { "${name}-amd64":
      command       => "cowbuilder --update --basepath=${cow_root}",
      environment   => ["DIST=${name}", 'ARCH=amd64', 'PATH=/usr/sbin:/usr/bin:/bin:/sbin'],
      hour          => '2',
      minute        => '15',
      name          => "cowbuilder update for ${name}-amd64",
      user          => root,
    }
  }
}
