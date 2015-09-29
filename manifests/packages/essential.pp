# This class brings in all of the packages that are essential and commonly used
# when building with debbuild or dpkg-buildpackage. It also brings in the
# needed packages for building Puppet Labs products.

class debbuilder::packages::essential (
  $ensure = present,
){

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

  ensure_packages( $builder_packages, {
    ensure => $ensure,
  })

  include git
}
