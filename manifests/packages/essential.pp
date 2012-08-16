class debbuilder::packages::essential {

  $builder_packages = [
    "devscripts",
    "quilt",
    "dpatch",
    "make",
    "cdbs",
    "build-essential",
    "rake",
    "ruby-rspec",
    "git",
    "pristine-tar",
  ]

  package { $builder_packages: ensure => present, }

}
