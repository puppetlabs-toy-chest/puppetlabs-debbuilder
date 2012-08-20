require 'spec_helper'

describe 'debbuilder::setup::cows', :type => :class do
  [
     {
       :cows      => [ "precise", "squeeze"],
       :cow_root  => "/var/cows/root",
       :pe        => true,
      },
     {
       :pe        => "not a bool",
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

      context "#{(!!param_hash[:pe] == param_hash[:pe]) ? '$pe is a valid bool' : '$pe is not a valid bool'}" do
        if param_hash[:pe] == true or param_hash[:pe] == false
          context "all the cows should be there" do
            param_hash[:cows].each do |cow|
              it { should contain_debbuilder__setup__cow_exec(cow) }
            end
          end

          if param_hash[:pe] == true
            it { should contain_file("pluto-build-keyring.gpg").with({
                :path     => "/usr/share/keyrings/pluto-build-keyring.gpg",
                :ensure   => "file",
                :source   => "puppet:///modules/debbuilder/pluto-build-keyring.gpg",
                :owner    => "root",
                :group    => "root",
                :mode     => "0644",
              })
            }
          elsif param_hash[:pe] == false
            it { should_not contain_file("pluto-build-keyring.gpg").with({
                :path     => "/usr/share/keyrings/pluto-build-keyring.gpg",
                :ensure   => "file",
                :source   => "puppet:///modules/debbuilder/pluto-build-keyring.gpg",
                :owner    => "root",
                :group    => "root",
                :mode     => "0644",
              })
            }
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
        else
          it "should throw an error if $pe isn't a bool" do
            expect { should raise_error(Puppet::Error) }
          end
        end
      end
    end
  end
end
