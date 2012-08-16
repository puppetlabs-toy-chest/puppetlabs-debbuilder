require 'spec_helper'

describe 'debbuilder::packages::essential', :type => :class do
  packages = [
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

  packages.each do |pkg|
    it { should contain_package(pkg).with_ensure("latest") }
  end
end
