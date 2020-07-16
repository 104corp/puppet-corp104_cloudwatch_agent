class corp104_cloudwatch_agent::service {
  service { 'awslogs':
    ensure => $corp104_cloudwatch_agent::service_ensure,
    enable => $corp104_cloudwatch_agent::service_enable,
  }
}
