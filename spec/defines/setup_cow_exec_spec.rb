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
      arches = ['i386', 'amd64', 'ppc', 'powerpc', 'ppc32', 'ppc64', 'arm']

      arches.each do | arch_fact |
        context "on #{arch_fact}" do
          let(:facts) do { :architecture => arch_fact } end
          arches.each do | arch |
            if (arch_fact =~ /(amd64|i386)/)
              it do should contain_exec("#{title}-i386").with( {
                  :path         => "/usr/sbin:/usr/bin:/bin:/sbin",
                  :command      => "cowbuilder --create --basepath=#{param_hash[:cow_root]}/base-#{title}-powerpc.cow/ --debug",
                  :unless       => "test -e #{param_hash[:cow_root]}/base-#{title}-i386.cow",
                  :environment  => ["DIST=#{title}", "ARCH=i386"],
                  :logoutput    => "on_failure",
                  :user         => "root",
                  :timeout      => "0",
                } )
              end

              it do should contain_cron("#{title}-i386").with({
                  :name   => "cowbuilder update for #{title}-i386",
                  :ensure => 'absent',
                })
              end
            end
            if (arch_fact == /(amd64|arm(el|hf)?)/)
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
                  :name   => "cowbuilder update for #{title}-#{arch}",
                  :ensure => 'absent',
                })
              end
            end
            if (arch_fact =~ /(?i)(powerpc|ppc(64|32)?)/)
              it do should contain_exec("#{title}-powerpc").with( {
                  :path         => "/usr/sbin:/usr/bin:/bin:/sbin",
                  :command      => "cowbuilder --create --basepath=#{param_hash[:cow_root]}/base-#{title}-powerpc.cow/ --debug",
                  :unless       => "test -e #{param_hash[:cow_root]}/base-#{title}-powerpc.cow",
                  :environment  => ["DIST=#{title}", "ARCH=powerpc"],
                  :logoutput    => "on_failure",
                  :user         => "root",
                  :timeout      => "0",
                } )
              end

              it do should contain_cron("#{title}-powerpc").with({
                  :name   => "cowbuilder update for #{title}-powerpc",
                  :ensure => 'absent',
                })
              end
            end
          end
        end
      end
    end
  end
end
