require 'spec_helper'

describe 'debbuilder::setup::cow_exec', :type => :define do
  let(:title) { "squeeze" }

  let :cow_root do
    "/var/cache/pbuilder/cows"
  end

  let :params do
    { :cow_root => cow_root }
  end

  ['i386','amd64'].each do | arch |
    it { should contain_exec("#{title}-#{arch}").with( {
        'path'          => "/usr/sbin:/usr/bin:/bin:/sbin",
        'command'       => "cowbuilder --create --dist #{title} --architecture #{arch} --debug",
        'unless'        => "test -e #{cow_root}/base-#{title}-#{arch}.cow",
        'environment'   => ["DIST=#{title}", "ARCH=#{arch}"],
        'logoutput'     => "on_failure",
        'timeout'       => "0",
      } )
    }
  end
end
