# This class brings in all of the packages that are essential and commonly used
# when building with debbuild or dpkg-buildpackage. It also brings in the
# needed packages for building Puppet Labs products.

class debbuilder::packages::essential {
  $builder_packages = [
    'build-essential',
    'cdbs',
    'devscripts',
    'dh-make',
    'dpatch',
    'fakeroot',
    'make',
    'pristine-tar',
    'quilt',
    'rake',
  ]

  package { $builder_packages: ensure => present, }

  include git
}
