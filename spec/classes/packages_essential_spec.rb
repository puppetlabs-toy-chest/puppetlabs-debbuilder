require 'spec_helper'

describe 'debbuilder::packages::essential', :type => :class do
  let(:common_facts) do {
    :operatingsystem        => "Debian",
    :osfamily               => "Debian",
    :operatingsystemrelease => "Wheezy",
    }
  end

  packages = [
    "devscripts",
    "quilt",
    "dpatch",
    "dh-make",
    "make",
    "cdbs",
    "build-essential",
    "rake",
    "pristine-tar",
    "fakeroot",
  ]

  packages.each do |pkg|
    it { should contain_package(pkg).with_ensure("present") }
  end

  let(:facts) do common_facts end

  it { should contain_class("git") }
end
