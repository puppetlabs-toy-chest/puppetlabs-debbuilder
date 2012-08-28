# This class brings in all of the packages that are essential and commonly used
# when building with debbuild or dpkg-buildpackage. It also brings in the
# needed packages for building Puppet Labs products.

class debbuilder::packages::essential {

  $builder_packages = [
    "devscripts",
    "quilt",
    "dpatch",
    "dh-make",
    "make",
    "cdbs",
    "build-essential",
    "rake",
    "pristine-tar",
    "fakeroot",
  ]

  case $::lsbdistcodename {
    /(wheezy|sid|testing|quantal)/: { $rspec = "ruby-rspec" }
    default:                        { $rspec = "librspec-ruby" }
  }

  package { [$builder_packages, $rspec]: ensure => present, }

  include "git"

}
