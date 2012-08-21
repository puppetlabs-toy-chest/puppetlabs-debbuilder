require 'spec_helper'

describe 'debbuilder::packages::essential', :type => :class do
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
  ]

  mapping = [
    { :lsbrelease    => "wheezy",  :rspec => "ruby-rspec",    :git => "git", },
    { :lsbrelease    => "lucid",   :rspec => "librspec-ruby", :git => "git-core", },
  ]

  mapping.each do |fact_mapping|
    context "with fact :lsbdistcodename set to #{fact_mapping[:lsbrelease]}" do
      let(:facts) do { :lsbdistcodename => fact_mapping[:lsbrelease], } end

      (packages + [fact_mapping[:rspec]] + [fact_mapping[:git]]).each do |pkg|
        it { should contain_package(pkg).with_ensure("present") }
      end
    end
  end
end
