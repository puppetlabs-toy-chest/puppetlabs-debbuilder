require 'spec_helper'

describe 'debbuilder::packages::extra', :type => :class do
  packages = [
    "pbuilder",
    "cowbuilder",
    "cowdancer",
    "debian-keyring",
    "debian-archive-keyring",
    "keychain",
    "gnupg",
  ]

  packages.each do |pkg|
    it { should contain_package(pkg).with_ensure("present") }
  end
end
