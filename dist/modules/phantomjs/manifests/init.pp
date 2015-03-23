# Base class for phantomjs module
class phantomjs (
  $package_version = '1.9.7',
  $source_url = undef,
  $source_dir = '/opt',
  $install_dir = '/usr/local/bin',
  $package_update = false,
  $timeout = 300
) {

  # Base requirements
  if $::kernel != 'Linux' {
    fail('This module is supported only on Linux.')
  }

  ensure_packages('curl')
  ensure_packages('bzip2')

  # Ensure packages based on operating system exist
  case $::operatingsystem {
    /(?:CentOS|RedHat|Amazon|Scientific)/: {
      # Requirements for CentOS/RHEL according to phantomjs.org
      ensure_packages('fontconfig')
      ensure_packages('freetype')

      if $::operatingsystem == 'Amazon' {
        $libstdc_package = 'compat-libstdc++-33'
      } else {
        $libstdc_package = 'libstdc++'
      }

      ensure_packages($libstdc_package)
      ensure_packages('urw-fonts')

      $packages = [
        Package['curl'],
        Package['bzip2'],
        Package['fontconfig'],
        Package['freetype'],
        Package[$libstdc_package],
        Package['urw-fonts']
      ]
    }
    default: {
      ensure_packages('libfontconfig1')
      $packages = [
        Package['curl'],
        Package['bzip2'],
        Package['libfontconfig1']
      ]
    }
  }

  $pkg_src_url = $source_url ? {
    undef   => "https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-${package_version}-linux-${::hardwaremodel}.tar.bz2",
    default => $source_url,
  }

  exec { 'get phantomjs':
    command => "/usr/bin/curl --silent --show-error --location ${pkg_src_url} --output ${source_dir}/phantomjs.tar.bz2 \
      && mkdir ${source_dir}/phantomjs \
      && tar --extract --file=${source_dir}/phantomjs.tar.bz2 --strip-components=1 --directory=${source_dir}/phantomjs",
    creates => "${source_dir}/phantomjs/",
    require => $packages,
    timeout => $timeout
  }

  file { "${install_dir}/phantomjs":
    ensure => link,
    target => "${source_dir}/phantomjs/bin/phantomjs",
    force  => true,
  }

  if $package_update {
    exec { 'remove phantomjs':
      command => "/bin/rm -rf ${source_dir}/phantomjs",
      notify  => Exec[ 'get phantomjs' ]
    }
  }
}
