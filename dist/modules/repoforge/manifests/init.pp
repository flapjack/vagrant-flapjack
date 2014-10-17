# Class: repoforge
#
#  The class ensures repoforge repo is installed
#
# Parameters:
# [*enabled*]
#   An array of repository names to be enabled.  Default is ['rpmforge'].
#
# [*baseurl*]
#   The root of the repository baseurl parameter.  Default points to the main
#   Repoforge mirror; override this if you want to specify a different mirror.
#
# [*mirrorlist*]
#   The root of the repository mirrorlist parameter.  Default points to the
#   mirrorlist file on the main Repoforge mirror; override this if you want to
#   specify a different mirrorlist file.
#
# Actions:
#
# Requires:
# [*stdlib*]
#
# Sample Usage:
#  class {
#    'repoforge':
#      enabled => ['rpmforge','extras'],
#      baseurl => "http://mirror/el${::os_maj_version}/en/${::architecture}";
#  }
class repoforge (
  $enabled    = $repoforge::params::enabled,
  $baseurl    = $repoforge::params::baseurl,
  $mirrorlist = $repoforge::params::mirrorlist,
  $includepkgs = {},
  $exclude = {},
) inherits repoforge::params {

  validate_array($repoforge::enabled)
  validate_string($repoforge::baseurl,$repoforge::mirrorlist)

  if $::osfamily == 'RedHat' {
    $repolist = keys($repoforge::params::repos)

    repoforge::yumrepo {
      $repoforge::repolist:
        require     => Repoforge::Rpm_gpg_key['RPM-GPG-KEY-rpmforge-dag'],
        repos       => $repoforge::params::repos,
        baseurl     => $repoforge::baseurl,
        mirrorlist  => $repoforge::mirrorlist,
        enabled     => $repoforge::enabled,
        includepkgs => merge($repoforge::params::includepkgs, $includepkgs),
        exclude     => merge($repoforge::params::exclude, $exclude),
    }

    file {'/etc/pki/rpm-gpg/RPM-GPG-KEY-rpmforge-dag' :
      ensure => present,
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      source => 'puppet:///modules/repoforge/RPM-GPG-KEY-rpmforge-dag',
    }

    repoforge::rpm_gpg_key { 'RPM-GPG-KEY-rpmforge-dag' :
      path => '/etc/pki/rpm-gpg/RPM-GPG-KEY-rpmforge-dag',
    }

  } else {
    notice ("Your operating system ${::operatingsystem} will not have the RepoForge repository applied")
  }
}
