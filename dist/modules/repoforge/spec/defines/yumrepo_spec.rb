# spec/defines/yumrepo_spec.rb

require 'spec_helper'

describe 'repoforge::yumrepo' do
  
  let(:title) { 'rpmforge' }

  let(:params) { {
    :repos => {'rpmforge' => 'rpmforge'},
    :baseurl  => 'http://apt.sw.be/redhat/el6/en/i386',
    :mirrorlist => 'http://mirrorlist.repoforge.org/el6',
    :enabled => ['rpmforge'],
    :includepkgs => { 'rpmforge' => 'include1 include2' },
    :exclude => { 'rpmforge' => 'exclude1 exclude2' },
  } }

  let(:facts) { {
      :os_maj_version => 6,
  } }
 
  it 'set yum repository'  do
    should contain_yumrepo('rpmforge').with({
      'descr'       => 'RHEL 6 - RPMforge.net - rpmforge',
      'baseurl'     => 'http://apt.sw.be/redhat/el6/en/i386/rpmforge',
      'mirrorlist'  => 'http://mirrorlist.repoforge.org/el6/mirrors-rpmforge',
      'protect'     => 0,
      'gpgcheck'    => 1,
      'gpgkey'      => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-rpmforge-dag',
      'includepkgs' => 'include1 include2',
      'exclude'     => 'exclude1 exclude2',
    })
  end

end
