# define: repoforge::yumrepo
#
#  The actual report configuration
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
# [*repos*]
#   Array of repositories to declare
#
# Actions:
#
# Requires:
# [*stdlib*]
#
# Sample Usage:
#    repoforge::yumrepo {
#      $repoforge::repolist:
#        require    => Repoforge::Rpm_gpg_key['RPM-GPG-KEY-rpmforge-dag'],
#        repos      => $repoforge::params::repos,
#        baseurl    => $repoforge::baseurl,
#        mirrorlist => $repoforge::mirrorlist,
#        enabled    => $repoforge::enabled;
#    }
#
define repoforge::yumrepo (
  $repos,
  $repo_shortname = $name,
  $baseurl,
  $mirrorlist,
  $enabled,
  $includepkgs,
  $exclude,
) {
  $reponame = $repos[$title]

  validate_array($enabled)

  yumrepo {
    $reponame :
      descr       => "RHEL ${::os_maj_version} - RPMforge.net - ${reponame}",
      baseurl     => "${baseurl}/${reponame}",
      mirrorlist  => "${mirrorlist}/mirrors-${reponame}",
      enabled     => bool2num(member($enabled,$title)),
      protect     => 0,
      gpgcheck    => 1,
      gpgkey      => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-rpmforge-dag',
      includepkgs => $includepkgs[$repo_shortname],
      exclude     => $exclude[$repo_shortname],
  }
}
