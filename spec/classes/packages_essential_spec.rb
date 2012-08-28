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

  mapping = [
    { :lsbrelease    => "wheezy",  :rspec => "ruby-rspec", },
    { :lsbrelease    => "lucid",   :rspec => "librspec-ruby", },
  ]

  mapping.each do |fact_mapping|
    context "with fact :lsbdistcodename set to #{fact_mapping[:lsbrelease]}" do
      let(:facts) do common_facts.merge({ :lsbdistcodename => fact_mapping[:lsbrelease], }) end

      (packages + [fact_mapping[:rspec]]).each do |pkg|
        it { should contain_package(pkg).with_ensure("present") }
      end
    end
  end

  let(:facts) do common_facts end

  it { should contain_class("git") }
end
