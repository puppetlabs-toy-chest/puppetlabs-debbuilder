# This defined type takes one parameter, the cow_root where the cows will be
# built.  Building cows takes a long time, so both execs in this defined type
# have timeout set to 0. In my tests, each cow took between 5 and 10 minutes to
# complete. That totals to between 90 and 180 minutes for a default run. The
# defined type also lays down two cron jobs to maintain the cows, one for each.

define debbuilder::setup::cow_exec ( $cow_root = '/var/cache/pbuilder' ) {
  if ($::architecture == 'i386' or $::architecture == 'amd64') {
    exec { "${name}-i386":
      path          => '/usr/sbin:/usr/bin:/bin:/sbin',
      command       => "cowbuilder --create --basepath=${cow_root}/base-${name}-i386.cow/ --debug",
      unless        => "test -e ${cow_root}/base-${name}-i386.cow",
      environment   => ["DIST=${name}", 'ARCH=i386'],
      logoutput     => on_failure,
      user          => root,
      timeout       => 0,
    }

    cron { "${name}-i386":
      command       => "cowbuilder --update --basepath=${cow_root}/base-${name}-i386.cow > /dev/null 2>&1",
      environment   => ["DIST=${name}", 'ARCH=i386', 'PATH=/usr/sbin:/usr/bin:/bin:/sbin'],
      hour          => '2',
      minute        => '15',
      name          => "cowbuilder update for ${name}-i386",
      user          => root,
    }
  }

  if ($::architecture =~ /(?i)(amd64|arm(el|hf)?)/) {
    exec { "${name}-${::architecture}":
      path          => '/usr/sbin:/usr/bin:/bin:/sbin',
      command       => "cowbuilder --create --basepath=${cow_root}/base-${name}-${::architecture}/ --debug",
      unless        => "test -e ${cow_root}/base-${name}-${::architecture}.cow",
      environment   => ["DIST=${name}", "ARCH=${::architecture}"],
      logoutput     => on_failure,
      user          => root,
      timeout       => 0,
    }

    cron { "${name}-${::architecture}":
      command       => "cowbuilder --update --basepath=${cow_root}/base-${name}-${::architecture}.cow > /dev/null 2>&1",
      environment   => ["DIST=${name}", "ARCH=${::architecture}", 'PATH=/usr/sbin:/usr/bin:/bin:/sbin'],
      hour          => '2',
      minute        => '15',
      name          => "cowbuilder update for ${name}-${::architecture}",
      user          => root,
    }
  }

  if ($::architecture =~ /(?i)(powerpc|ppc(64|32)?)$/) {
    exec { "${name}-powerpc":
      command       => "cowbuilder --create --basepath=${cow_root}/base-${name}-powerpc.cow/ --debug",
      unless        => "test -e ${cow_root}/base-${name}-powerpc.cow",
      environment   => ["DIST=${name}", "ARCH=powerpc"],
      logoutput     => on_failure,
      user          => root,
      timeout       => 0,
    }

    cron { "${name}-powerpc":
      command       => "cowbuilder --update --basepath=${cow_root}/base-${name}-powerpc.cow > /dev/null 2>&1",
      environment   => ["DIST=${name}", "ARCH=powerpc", 'PATH=/usr/sbin:/usr/bin:/bin:/sbin'],
      hour          => '2',
      minute        => '15',
      name          => "cowbuilder update for ${name}-powerpc",
      user          => root,
    }
  }
}
