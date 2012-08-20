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
    "git",
    "pristine-tar",
  ]

  mapping = [
    { :lsbrelease    => "wheezy",  :rspec => "ruby-rspec", },
    { :lsbrelease    => "lucid",   :rspec => "librspec-ruby", },
  ]

  mapping.each do |fact_mapping|
    context "with fact :lsbdistcodename set to #{fact_mapping[:lsbrelease]}" do
      let(:facts) do { :lsbdistcodename => fact_mapping[:lsbrelease], } end

      (packages + [fact_mapping[:rspec]]).each do |pkg|
        it { should contain_package(pkg).with_ensure("present") }
      end
    end
  end
end
