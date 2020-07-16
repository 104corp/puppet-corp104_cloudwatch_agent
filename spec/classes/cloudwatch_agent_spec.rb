require 'spec_helper'

describe 'corp104_cloudwatch_agent', :type => :class do

  let :facts do
    {
      :concat_basedir => '/dne',
    }
  end

  it do
    should contain_class('corp104_cloudwatch_agent')
  end

  it do
    should compile.with_all_deps
  end

end
