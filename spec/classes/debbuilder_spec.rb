require 'spec_helper'

describe 'debbuilder', :type => :class do
  let :default_params do
    {
      :pe       => false,
      :use_cows => false,
      :cows     => :undef,
      :cow_root => :undef
    }
  end

  [{},
    {
      :pe       => true,
    },
    {
      :use_cows => true,
    },
    {
      :pe       => true,
      :use_cows => true,
      :cows     => ["precise"],
      :cow_root => "/var/root/cows",
    }
  ].each do |param_set|
    describe "when #{param_set == {} ? "using default" : "specifying"} class parameters" do
      let :param_hash do
        default_params.merge(param_set)
      end

      let :params do
        param_set
      end

      it { should contain_class("debbuilder::packages::essential") }

      it do
        if param_hash[:use_cows]
          if param_hash[:cows] != :undef
            should contain_class("debbuilder::packages::extra")
            should contain_class("debbuilder::setup::cows").with_cows(param_hash[:cows])
          elsif param_hash[:cow_root] != :undef
            should contain_class("debbuilder::packages::extra")
            should contain_class("debbuilder::setup::cows").with_cow_root(param_hash[:cow_root])
          else
            should contain_class("debbuilder::packages::extra")
            should contain_class("debbuilder::setup::cows")
          end
        else
          should_not contain_class("debbuilder::packages::extra")
          should_not contain_class("debbuilder::setup::cows")
        end
      end
    end
  end
end
