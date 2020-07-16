# Class: corp104_cloudwatch_agent
#
# This class installs the cloudwatch log shipper and helps manage which
# files are shipped.
#
class corp104_cloudwatch_agent (
  $package_install = $corp104_cloudwatch_agent::params::package_install,
  $package_ensure  = $corp104_cloudwatch_agent::params::package_ensure,
  $installer_url   = $corp104_cloudwatch_agent::params::installer_url,
  $service_ensure  = $corp104_cloudwatch_agent::params::service_ensure,
  $service_enable  = $corp104_cloudwatch_agent::params::service_enable,
  $region          = $corp104_cloudwatch_agent::params::region,
  $state_file      = $corp104_cloudwatch_agent::params::state_file,
  $logs            = {},
) inherits corp104_cloudwatch_agent::params {

  validate_string($region, $state_file)
  validate_hash($logs)

  anchor { 'corp104_cloudwatch_agent::begin': }
  -> class { 'corp104_cloudwatch_agent::package': }
  -> class { 'corp104_cloudwatch_agent::config': }
  -> class { 'corp104_cloudwatch_agent::service': }
  -> anchor { 'corp104_cloudwatch_agent::end': }

  if !empty($logs) {
    create_resources('corp104_cloudwatch_agent::log', $logs)
  }

}
