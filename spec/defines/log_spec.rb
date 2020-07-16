require 'spec_helper'

describe 'corp104_cloudwatch_agent::log', :type => :define do

  let :facts do
    {
      :concat_basedir => '/dne',
    }
  end

  let :title do
    '/var/log/syslog'
  end

end
