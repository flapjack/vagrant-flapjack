# spec/defines/rpm_gpg_key.pp

require 'spec_helper'

describe 'repoforge::rpm_gpg_key' do

  let(:title) {'RPM-GPG-KEY-rpmforge-dag'}

  let(:params) { {
    'name' => 'RPM-GPG-KEY-rpmforge-dag',
    'path' => '/etc/pki/rpm-gpg/RPM-GPG-KEY-rpmforge-dag',
  } }

  it 'imports the gpg key into rpm' do
    should contain_exec('import-RPM-GPG-KEY-rpmforge-dag').with({
        'command' => 'rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-rpmforge-dag',
        'unless'  => "rpm -q gpg-pubkey-`$(echo $(gpg --throw-keyids < /etc/pki/rpm-gpg/RPM-GPG-KEY-rpmforge-dag) | cut --characters=11-18 | tr [A-Z] [a-z])`",
    })
  end

end
