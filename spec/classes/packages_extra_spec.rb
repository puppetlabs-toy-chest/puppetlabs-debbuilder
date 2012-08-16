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

  it do should contain_package("ubuntu-keyring").with({
      :ensure   => 'present',
      :source   => "puppet:///modules/debbuilder/ubuntu-keyring_2012.05.19_all.deb",
      :provider => 'dpkg',
    })
  end
end
