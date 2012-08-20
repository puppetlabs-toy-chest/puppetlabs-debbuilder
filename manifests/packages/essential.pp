class debbuilder::packages::essential {

  $builder_packages = [
    "devscripts",
    "quilt",
    "dpatch",
    "make",
    "cdbs",
    "build-essential",
    "rake",
    "git",
    "pristine-tar",
  ]

  case $::lsbdistcodename {
    /(wheezy|sid|testing|quantal)/: { $rspec = "ruby-rspec" }
    default:                        { $rspec = "librspec-ruby" }
  }

  package { [$builder_packages, $rspec]: ensure => present, }

}
