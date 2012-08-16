require 'spec_helper'

describe 'debbuilder::setup::pe', :type => :class do
  it { should contain_file("pluto-build-keyring.gpg").with({
      :path     => "/usr/share/keyrings/pluto-build-keyring.gpg",
      :ensure   => "file",
      :source   => "puppet:///modules/debbuilder/pluto-build-keyring.gpg",
      :owner    => "root",
      :group    => "root",
      :mode     => "0644",
    })
  }
end
