# Class: repoforge::params
#
#  The repoforge configuration settings
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class repoforge::params {

  $baseurl = "http://apt.sw.be/redhat/el${::os_maj_version}/en/${::architecture}"
  $mirrorlist = "http://mirrorlist.repoforge.org/el${::os_maj_version}"

  $repos = {'extras'=>'rpmforge-extras','rpmforge'=>'rpmforge','testing'=>'rpmforge-testing'}

  $includepkgs = { 'extras'=> absent, 'rpmforge' => absent, 'testing'=> absent }
  $exclude = { 'extras'=> absent ,'rpmforge' => absent, 'testing'=> absent }

  $enabled = [ 'rpmforge' ]

}
