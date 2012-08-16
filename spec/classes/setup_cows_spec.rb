require 'spec_helper'

describe 'debbuilder::setup::cows', :type => :class do
    [{ :cows    => [ "lucid", "squeeze", "natty", "oneiric", "precise", "quantal", "sid", "stable", "testing" ] },
     { :cows    => [ "precise", "squeeze"] }
  ].each_with_index do |param_set, i|
    describe "when #{i == 0 ? "using default" : "specifying"} class parameters" do
      let :params do
        param_set
      end

      describe "all the cows should be there" do
        param_set[:cows].each do |cow|
          it { should contain_debbuilder__setup__cow_exec(cow) }
        end
      end

      it { should contain_file("puppetlabs-keyring.gpg").with({
        :path       => "/usr/share/keyrings/puppetlabs-keyring.gpg",
        :ensure     => "file",
        :source     => "puppet:///modules/debbuilder/puppetlabs-keyring.gpg",
        :owner      => "root",
        :group      => "root",
        :mode       => "0644",
        })
      }

      [ { :pe   => false }, { :pe   => true } ].each do |fact_set|
        let :facts do
          fact_set
        end

        it do
          should contain_file("pbuilderrc").with({
            :path       => "/etc/pbuilderrc",
            :ensure     => "file",
            :owner      => "root",
            :content    => (fact_set[:pe] ? /PE_VER/ : /DEBOOTSTRAP/),
            :group      => "root",
            :mode       => "0644",
          })
        end
      end

      it { should_not contain_file("pluto-build-keyring.gpg") }
    end
  end
end
