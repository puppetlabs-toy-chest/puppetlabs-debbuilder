# Puppetlabs-debbuilder Module #

This module is designed to stand up a debian builder. It can take care of
either adding the packages required to build using debuild or using pbuilder.
If desired it can also set up the appropriate cows for a pbuilder/cowbuilder
solution. It brings in keyrings for debian and ubuntu and lays down a
pbuilderrc in /etc to add the correct repos to a given cow.

## Example Usage ##
<pre>
    class { "debbuilder":
      pe => false,
      use_cows => true,
      cows => ["lucid", "squeeze", "precise"],
    }
</pre>

  This incantation will create i386 and amd64 cows for lucid, squeeze and
  precise and install the needed packages on the builder. The cows will be set
  up with the correct keys for their repos.

### The Pieces ###

  The module has four classes and one defined type included. The classes and defined type can be used to create a builder setup as desired, but the base debbuilder class takes three parameters that should be sufficient for most situations.

#### debbuilder ####

  The main class brings in the three included classes and has three parameters to customize behavior. use\_cows can be set to true or false, and if false only the essential packages will be brought in. If true, the extra packages will be brought in as well and cows will be setup using the debbuilder::setup::cow\_exec defined type. The cows parameter can be used to customize which cows will be created. If left undefined the cow\_exec defined type will create cows for all currently supported debian and ubuntu varieties. The pe parameter enables internal Puppet Labs repos for the builder cow configs and also installs an internal builder public keyring.

#### debbuilder::packages::essential ####

  This class will bring in all of the essential packages for building debian packages using debuild or dpkg-buildpackage.

#### debbuilder::packages::extra ####

  This class will bring in all of the packages needed for building debian packages using cowbuilder or pdebuild.

#### debbuilder::setup::cows ####

  This class takes a cows parameter and will setup cows for both i386 and amd64 for either the supplied cows, or for all currently supported debian and ubuntu varieties if $cows is not provided. This class also brings in the puppetlabs keyring for the cows, so they can use the puppetlabs repos to bring in build dependencies. It also lays down a customized pbuilderrc to bootstrap the builder cows.

#### debbuilder::setup::cow\_exec ####

  This defined type adds a cow for both i386 and amd64 arches for a given debian or ubuntu variety. It also includes nightly cron jobs that keep the cow up to date using the default repos. The defined type takes a cow\_root parameter that can be used to customize the base location of the cow. It defaults to /var/cache/pbuilder.


