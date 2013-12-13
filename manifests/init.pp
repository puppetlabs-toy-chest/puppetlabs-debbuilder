# This is the main entry to the debbuilder module. It takes four parameters,
# three of which get passed down into sub-classes. $pe customizes the module
# for internal Puppet Labs builds, $use_cows sets up cows as builders and
# brings in all the dependencies to set cows up. $cows and $cow_root customize
# which cows are build during the setup phase and which basepath to use when
# setting the cows up (if $use_cows is set to true). $debian_mirror,
# $debian_archive_mirror, and $ubuntu_mirror can be used to specify the mirrors
# that will be used by pbuilder/cowbuilder during dependency resolution/OS
# build. $other_mirror can be used to specify an extra repository in addition
# to the OS mirror to use when satisfying dependencies. If not specified, this
# defaults to apt.puppetlabs.com (which has been the historic behavior). If
# specifies, it replaces apt.puppetlabs.com. Note that unlike the debian and
# ubuntu OS mirrors, this mirror must be specified as a repo config, e.g.:
#
# "deb http://apt.puppetlabs.com ${DIST} main dependencies"
#
# where $DIST is wheezy, precise, etc.
#
# $install_pl_keyring enables the installation of the Puppet Labs gpg keyring.
# This defaults to true, which has been the historic behavior.
# $debian_components and $ubuntu_components allow you to specify the exact repo
# components to select when satisfying dependencies. By default on debian this
# is 'main contrib non-free' and on ubuntu this is 'main restricted universe
# multiverse.'

class debbuilder (
  $pe = false,
  $use_cows = false,
  $cows = undef,
  $cow_root = undef,
  $debian_mirror = undef,
  $debian_archive_mirror = undef,
  $debian_components = undef,
  $ubuntu_mirror = undef,
  $ubuntu_components = undef,
  $other_mirror = undef,
  $install_pl_keyring = true,
) {
  include debbuilder::packages::essential

  if ($use_cows) {
    class { 'debbuilder::packages::extra':
      pe => $pe,
    }

    class { 'debbuilder::setup::cows':
      cows => $cows,
      cow_root => $cow_root,
      pe => $pe,
    }
  }
}
