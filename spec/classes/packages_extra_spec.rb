require 'spec_helper'

describe 'debbuilder::packages::extra', :type => :class do
  let(:facts) do {
    :operatingsystem        => "Debian",
    :osfamily               => "Debian",
    :operatingsystemrelease => "Wheezy",
    }
  end

  packages = [
    "pbuilder",
    "cowbuilder",
    "cowdancer",
    "debian-keyring",
    "debian-archive-keyring",
    "keychain",
  ]

  packages.each do |pkg|
    it { should contain_package(pkg).with_ensure("present") }
  end

  it { should contain_class("gpg") }

end
