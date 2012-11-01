# This class brings in all of the packages that are needed to build packages
# using pbuilder or pdebuild. It also includes bash-completion, which is
# helpful when dealing with cowbuilder on the command line.  The debian keyring
# packages are needed for bootstrapping the cows during setup.

class debbuilder::packages::extra {
  $extra_packages = [
    'bash-completion',
    'cowbuilder',
    'cowdancer',
    'debian-archive-keyring',
    'debian-keyring',
    'pbuilder',
  ]

  package { $extra_packages: ensure => present, }
}
