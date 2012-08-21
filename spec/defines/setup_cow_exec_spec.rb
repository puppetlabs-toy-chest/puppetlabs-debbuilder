require 'spec_helper'

describe 'debbuilder::setup::cow_exec', :type => :define do
  let(:title) { "squeeze" }

  let :default_params do
    { :cow_root => "/var/cache/pbuilder", }
  end

  [
    { :cow_root => "/var/cows/root", },
    {},
  ].each do |param_set|
    context "when #{param_set == {} ? "using default" : "specifying"} class parameters" do
      let :param_hash do
        default_params.merge(param_set)
      end

      let :params do
        param_set
      end
      arches = ['i386', 'amd64']

      arches.each do | arch_fact |
        context "on #{arch_fact}" do
          let(:facts) do { :architecture => arch_fact } end
          arches.each do | arch |
            if (arch_fact == "amd64") or (arch_fact == arch)
              it do should contain_exec("#{title}-#{arch}").with( {
                  :path         => "/usr/sbin:/usr/bin:/bin:/sbin",
                  :command      => "cowbuilder --create --basepath=#{param_hash[:cow_root]}/base-#{title}-#{arch}.cow/ --debug",
                  :unless       => "test -e #{param_hash[:cow_root]}/base-#{title}-#{arch}.cow",
                  :environment  => ["DIST=#{title}", "ARCH=#{arch}"],
                  :logoutput    => "on_failure",
                  :user         => "root",
                  :timeout      => "0",
                } )
              end

              it do should contain_cron("#{title}-#{arch}").with({
                  :command      => "cowbuilder --update --basepath=#{param_hash[:cow_root]}",
                  :environment  => "DIST=#{title} ARCH=#{arch} PATH=/usr/sbin:/usr/bin:/bin:/sbin",
                  :hour         => "2",
                  :minute       => "15",
                  :user         => "root",
                  :name         => "cowbuilder update for #{title}-#{arch}",
                })
              end
            end
          end
        end
      end
    end
  end
end
