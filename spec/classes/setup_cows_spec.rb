require 'spec_helper'

describe 'debbuilder::setup::cows', :type => :class do
  [
     {
       :cows      => [ "precise", "squeeze"],
       :cow_root  => "/var/cows/root",
       :pe        => true,
      },
      {},
  ].each do |param_set|
    context "when #{param_set == {} ? "using default" : "specifying"} class parameters" do
      default_params =
      { :cows     => [ "lucid", "squeeze", "natty", "oneiric", "precise", "quantal", "sid", "stable", "testing" ],
        :cow_root => "/var/cache/pbuilder",
        :pe       => false,
      }

      param_hash = default_params.merge(param_set)

      let :params do
        param_set
      end

      context "all the cows should be there" do
        param_hash[:cows].each do |cow|
          it { should contain_debbuilder__setup__cow_exec(cow) }
        end
      end

      if param_hash[:pe]
        it do should contain_file("pluto-build-keyring.gpg").with({
            :path     => "/usr/share/keyrings/pluto-build-keyring.gpg",
            :ensure   => "file",
            :source   => "puppet:///modules/debbuilder/pluto-build-keyring.gpg",
            :owner    => "root",
            :group    => "root",
            :mode     => "0644",
          })
        end
      else
        it do should_not contain_file("pluto-build-keyring.gpg").with({
            :path     => "/usr/share/keyrings/pluto-build-keyring.gpg",
            :ensure   => "file",
            :source   => "puppet:///modules/debbuilder/pluto-build-keyring.gpg",
            :owner    => "root",
            :group    => "root",
            :mode     => "0644",
          })
        end
      end

      it do should contain_file("puppetlabs-keyring.gpg").with({
        :path       => "/usr/share/keyrings/puppetlabs-keyring.gpg",
        :ensure     => "file",
        :source     => "puppet:///modules/debbuilder/puppetlabs-keyring.gpg",
        :owner      => "root",
        :group      => "root",
        :mode       => "0644",
        })
      end

      it do
        should contain_file("pbuilderrc").with({
          :path       => "/etc/pbuilderrc",
          :ensure     => "file",
          :owner      => "root",
          :content    => (param_hash[:pe] ? /PE_VER/ : /DEBOOTSTRAP/),
          :group      => "root",
          :mode       => "0644",
        })
      end
    end
  end
end
