class corp104_cloudwatch_agent::config (
  Optional[String] $http_proxy = '',
) {

  if $corp104_cloudwatch_agent::package_install {
    $awslogs_config_dir = '/etc/awslogs'
  } else {
    $awslogs_config_dir = '/var/awslogs/etc'
  }

  concat { 'awslogs.conf':
    path   => "${awslogs_config_dir}/awslogs.conf",
    notify => Service['awslogs'],
  }

  concat::fragment { 'general':
    target  => 'awslogs.conf',
    content => template("${module_name}/awslogs.conf.erb"),
    order   => '01',
  }

  file { "${awslogs_config_dir}/proxy.conf":
    ensure  => 'file',
    content => template("${module_name}/proxy.conf.erb"),
    notify  => Service['awslogs'],
  }
}
