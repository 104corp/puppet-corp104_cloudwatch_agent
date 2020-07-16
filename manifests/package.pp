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

    exec { 'install-awslogs':
      command => "env && curl ${corp104_cloudwatch_agent::installer_url} |\
        python - -r ${corp104_cloudwatch_agent::region} -n -c /tmp/aws.conf",
      creates => '/var/awslogs/etc/aws.conf',
      cwd     => '/tmp',
      path    => ['/usr/bin', '/usr/local/sbin', '/usr/sbin', '/sbin', '/bin'],
      require => [Package['curl'], File['/tmp/aws.conf'] ],
    }
  }
}
