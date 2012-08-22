require 'spec_helper'

describe 'debbuilder::setup::cows', :type => :class do
  let(:facts) do {
    :operatingsystem        => "Debian",
    :osfamily               => "Debian",
    :operatingsystemrelease => "Wheezy",
    }
  end
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

          keyrings = ["ubuntu-archive-keyring.gpg", "ubuntu-master-keyring.gpg", "ubuntu-archive-removed-keys.gpg", "puppetlabs-keyring.gpg"]
          debootstraps = ["oneiric", "precise", "quantal", "wheezy"]

          if param_hash[:pe] == true
            it do should contain_file("pluto-build-keyring.gpg").with({
                :path     => "/usr/share/keyrings//pluto-build-keyring.gpg",
                :ensure   => "file",
                :source   => "puppet:///modules/debbuilder//pluto-build-keyring.gpg",
                :owner    => "root",
                :group    => "root",
                :mode     => "0644",
              })
            end

            it do should contain_debbuilder__util__file_on_disk("pluto-build-keyring.gpg").with({
                :source     => "puppet:///modules/debbuilder/",
                :target     => "/usr/share/keyrings/",
              })
            end
          elsif param_hash[:pe] == false
            it do should_not contain_file("pluto-build-keyring.gpg").with({
                :path     => "/usr/share/keyrings//pluto-build-keyring.gpg",
                :ensure   => "file",
                :source   => "puppet:///modules/debbuilder//pluto-build-keyring.gpg",
                :owner    => "root",
                :group    => "root",
                :mode     => "0644",
              })
            end

            it do should_not contain_debbuilder__util__file_on_disk("pluto-build-keyring.gpg").with({
                :source     => "puppet:///modules/debbuilder/",
                :target     => "/usr/share/keyrings/",
              })
            end
          end

          keyrings.each do |key|
            it do should contain_file(key).with({
                :path       => "/usr/share/keyrings//#{key}",
                :ensure     => "file",
                :source     => "puppet:///modules/debbuilder//#{key}",
                :owner      => "root",
                :group      => "root",
                :mode       => "0644",
              })
            end

            it do should contain_debbuilder__util__file_on_disk(key).with({
                :source     => "puppet:///modules/debbuilder/",
                :target     => "/usr/share/keyrings/",
              })
            end
          end

          debootstraps.each do |script|
            it do should contain_file(script).with({
                :path       => "/usr/share/debootstrap/scripts//#{script}",
                :ensure     => "file",
                :source     => "puppet:///modules/debbuilder//#{script}",
                :owner      => "root",
                :group      => "root",
                :mode       => "0644",
              })
            end

            it do should contain_debbuilder__util__file_on_disk(script).with({
                :source     => "puppet:///modules/debbuilder/",
                :target     => "/usr/share/debootstrap/scripts/",
              })
            end
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

          it do
            should contain_file(param_hash[:cow_root]).with({
              :ensure   => "directory",
              :owner    => "root",
              :group    => "root",
              :mode     => "0755",
            })
          end

          it do
            should contain_exec(param_hash[:cow_root]).with({
              :command    => "/bin/mkdir -p '#{param_hash[:cow_root]}'",
              :user       => "root",
              :path       => "/usr/bin:/bin",
              :unless     => "test -d '#{param_hash[:cow_root]}'",
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
