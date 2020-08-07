class corp104_cloudwatch_agent::package {
  if $corp104_cloudwatch_agent::package_install {
    package { 'awslogs':
      ensure => $corp104_cloudwatch_agent::package_ensure,
    }
  } else {
    if !defined(Package['curl']){
      package { 'curl':
        ensure => present
      }
    }

    file { '/tmp/aws.conf':
      ensure  => present,
      content => template("${module_name}/aws.conf.erb"),
    }

    $agent_logs_url = "${corp104_cloudwatch_agent::installer_url}/awslogs-agent-setup.py"
    $agent_depen_url = "${corp104_cloudwatch_agent::installer_url}/AgentDependencies.tar.gz"

    exec { 'download-awslogs-depend':
      command => "curl $agent_depen_url -O && tar xvf AgentDependencies.tar.gz -C /tmp/",
      creates => '/tmp/AgentDependencies',
      cwd     => '/tmp',
      path    => ['/usr/bin', '/usr/local/sbin', '/usr/sbin', '/sbin', '/bin'],
      require => [Package['curl'], File['/tmp/aws.conf'] ],
    }

    exec { 'download-awslogs':
      command => "curl $agent_logs_url -O",
      creates => '/tmp/awslogs-agent-setup.py',
      cwd     => '/tmp',
      path    => ['/usr/bin', '/usr/local/sbin', '/usr/sbin', '/sbin', '/bin'],
      require => [Package['curl'], File['/tmp/aws.conf'] ],
    }

    exec { 'install-awslogs':
      command => "python /tmp/awslogs-agent-setup.py -r ${corp104_cloudwatch_agent::region} -n -c /tmp/aws.conf --dependency-path /tmp/AgentDependencies",
      creates => '/var/awslogs/etc/aws.conf',
      cwd     => '/tmp',
      path    => ['/usr/bin', '/usr/local/sbin', '/usr/sbin', '/sbin', '/bin'],
      require => [Package['curl'], File['/tmp/aws.conf'] ],
    }
  }
}
