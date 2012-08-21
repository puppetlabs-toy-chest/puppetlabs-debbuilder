require 'spec_helper'

describe 'debbuilder::setup::file_on_disk', :type => :define do
  let(:title) { "my_file" }

  let :default_params do
    { :source   => "puppet:///modules/debbuilder/",
      :target   => "/usr/share/",
    }
  end

  [
    { :source   => "/tmp/file/",
    },
    { :target   => "/var/lib/apt/keyrings",
    },
    {},
  ].each do |param_set|
    context "when #{param_set == {} ? "using default" : "specifying"} class parameters" do
      let :param_hash do
        default_params.merge(param_set)
      end

      let :params do
        param_set
      end

      it do
        should contain_file(title).with({
          :path     => "#{param_hash[:target]}/#{title}",
          :ensure   => "file",
          :source   => "#{param_hash[:source]}/#{title}",
          :owner    => "root",
          :group    => "root",
          :mode     => "0644",
        })
      end
    end
  end
end
