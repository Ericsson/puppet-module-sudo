require 'spec_helper'
describe 'sudo', type: :class do
  on_supported_os.sort.each do |os, os_facts|
    describe "on #{os} with default values for parameters" do
      let(:facts) { os_facts }

      it { is_expected.to contain_class('sudo') }
      it do
        is_expected.to contain_package('sudo-package').only_with(
          {
            'ensure'    => 'present',
            'name'      => 'sudo',
            'source'    => nil,
            'adminfile' => nil,
          },
        )
      end

      content_sudoers = <<-END.gsub(%r{^\s+\|}, '')
        |# This file is being maintained by Puppet.
        |# DO NOT EDIT
        |
        |Defaults    requiretty
        |Defaults    !visiblepw
        |Defaults    always_set_home
        |Defaults    env_reset
        |Defaults    env_keep = "COLORS DISPLAY HOSTNAME HISTSIZE INPUTRC KDEDIR LS_COLORS MAIL PS1 PS2 QTDIR USERNAME LANG LC_ADDRESS LC_CTYPE LC_COLLATE LC_IDENTIFICATION LC_MEASUREMENT LC_MESSAGES LC_MONETARY LC_NAME LC_NUMERIC LC_PAPER LC_TELEPHONE LC_TIME LC_ALL LANGUAGE LINGUAS _XKB_CHARSET XAUTHORITY"
        |Defaults    secure_path = /sbin:/bin:/usr/sbin:/usr/bin
        |root  ALL=(ALL)   ALL
        |## Read drop-in files from /etc/sudoers.d (the # here does not mean a comment)
        |#includedir /etc/sudoers.d
      END
      # rubocop:enable LineLength

      it do
        is_expected.to contain_file('/etc/sudoers').only_with(
          {
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0440',
            'content' => content_sudoers
          },
        )
      end

      it do
        is_expected.to contain_file('/etc/sudoers.d').only_with(
          {
            'ensure'  => 'directory',
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0750',
            'recurse' => true,
            'purge'   => true,
          },
        )
      end
    end
  end

  # The following tests are OS independent, so we only test one supported OS
  redhat = {
    supported_os: [
      {
        'operatingsystem'        => 'RedHat',
        'operatingsystemrelease' => ['7'],
      },
    ],
  }

  on_supported_os(redhat).each do |os, os_facts|
    let(:facts) { os_facts }

    describe "on #{os} with package set to valid string" do
      let(:params) { { package: 'unittest' } }

      it { is_expected.to contain_package('sudo-package').with_name('unittest') }
    end

    describe "on #{os} with package_source set to valid string" do
      let(:params) { { package_source: 'unittest' } }

      it { is_expected.to contain_package('sudo-package').with_source('unittest') }
    end

    describe "on #{os} with package_ensure set to valid string" do
      let(:params) { { package_ensure: 'absent' } }

      it { is_expected.to contain_package('sudo-package').with_ensure('absent') }
    end

    describe "on #{os} with package_manage set to valid false" do
      let(:params) { { package_manage: false } }

      it { is_expected.not_to contain_package('sudo-package') }
    end

    describe "on #{os} with package_adminfile set to valid string" do
      let(:params) { { package_adminfile: '/unit/test' } }

      it { is_expected.to contain_package('sudo-package').with_adminfile('/unit/test') }
    end

    describe "on #{os} with config_dir set to valid string" do
      let(:params) { { config_dir: '/unit/test' } }

      it { is_expected.to contain_file('/unit/test') }
      it { is_expected.to contain_file('/etc/sudoers').with_content(%r{#includedir \/unit\/test}) }
    end

    describe "on #{os} with config_dir_group set to valid string" do
      let(:params) { { config_dir_group: 'unittest' } }

      it { is_expected.to contain_file('/etc/sudoers.d').with_group('unittest') }
    end

    describe "on #{os} with config_dir_mode set to valid octet" do
      let(:params) { { config_dir_mode: '0242' } }

      it { is_expected.to contain_file('/etc/sudoers.d').with_mode('0242') }
    end

    describe "on #{os} with config_dir_ensure set to valid string" do
      let(:params) { { config_dir_ensure: 'absent' } }

      it { is_expected.to contain_file('/etc/sudoers.d').with_ensure('absent') }
    end

    describe "on #{os} with config_dir_purge set to valid hash" do
      let(:params) { { config_dir_purge: false } }

      it { is_expected.to contain_file('/etc/sudoers.d').with_purge(false) }
      it { is_expected.to contain_file('/etc/sudoers.d').with_recurse(false) }
    end

    describe "on #{os} with sudoers set to valid string" do
      let(:params) { { sudoers: { 'unit' => { 'content' => 'root ALL=(ALL) ALL' }, 'test' => { 'priority' => 20, 'source' => 'puppet:///unit/test' } } } }

      it { is_expected.to have_sudo__fragment_resource_count(2) }
      it { is_expected.to contain_sudo__fragment('unit').with_content('root ALL=(ALL) ALL') }
      it { is_expected.to contain_sudo__fragment('test').with_priority(20) }
      it { is_expected.to contain_sudo__fragment('test').with_source('puppet:///unit/test') }
      it { is_expected.to contain_file('10_unit') } # only needed for 100% resource coverage
      it { is_expected.to contain_file('20_test') } # only needed for 100% resource coverage
    end

    describe "on #{os} with sudoers_manage set to valid false" do
      let(:params) { { sudoers_manage: false } }

      it { is_expected.not_to contain_file('/etc/sudoers') }
      it { is_expected.not_to contain_file('/etc/sudoers.d') }
      it { is_expected.to have_sudo__fragment_resource_count(0) }
    end

    describe "on #{os} with config_file set to valid string" do
      let(:params) { { config_file: '/unit/test' } }

      it { is_expected.to contain_file('/unit/test') }
    end

    describe "on #{os} with config_file_group set to valid string" do
      let(:params) { { config_file_group: 'unittest' } }

      it { is_expected.to contain_file('/etc/sudoers').with_group('unittest') }
    end

    describe "on #{os} with config_file_owner set to valid string" do
      let(:params) { { config_file_owner: 'unittest' } }

      it { is_expected.to contain_file('/etc/sudoers').with_owner('unittest') }
    end

    describe "on #{os} with config_file_mode set to valid octet" do
      let(:params) { { config_file_mode: '0242' } }

      it { is_expected.to contain_file('/etc/sudoers').with_mode('0242') }
    end

    describe "on #{os} with requiretty set to valid false" do
      let(:params) { { requiretty: false } }

      it { is_expected.to contain_file('/etc/sudoers').with_content(%r{Defaults    !requiretty}) }
    end

    describe "on #{os} with visiblepw set to valid true" do
      let(:params) { { visiblepw: true } }

      it { is_expected.to contain_file('/etc/sudoers').with_content(%r{Defaults    visiblepw}) }
    end

    describe "on #{os} with always_set_home set to valid false" do
      let(:params) { { always_set_home: false } }

      it { is_expected.to contain_file('/etc/sudoers').with_content(%r{Defaults    !always_set_home}) }
    end

    describe "on #{os} with envreset set to valid false" do
      let(:params) { { envreset: false } }

      it { is_expected.to contain_file('/etc/sudoers').with_content(%r{Defaults    !env_reset}) }
    end

    describe "on #{os} with envkeep set to valid array" do
      let(:params) { { envkeep: ['UNIT', 'TEST'] } }

      it { is_expected.to contain_file('/etc/sudoers').with_content(%r{Defaults    env_keep = \"UNIT TEST\"}) }
    end

    describe "on #{os} with secure_path set to valid string" do
      let(:params) { { secure_path: '/unit:/test' } }

      it { is_expected.to contain_file('/etc/sudoers').with_content(%r{Defaults    secure_path = \/unit:\/test}) }
    end

    describe "on #{os} with root_allow_all set to valid false" do
      let(:params) { { root_allow_all: false } }

      it { is_expected.to contain_file('/etc/sudoers').without_content(%r{root  ALL=(ALL)   ALL}) }
    end

    describe "on #{os} with includedir set to valid false" do
      let(:params) { { includedir: false } }

      it { is_expected.to contain_file('/etc/sudoers').without_content(%r{#includedir}) }
    end

    describe "on #{os} with include_libsudo_vas set to valid true" do
      let(:params) { { include_libsudo_vas: true } }

      it { is_expected.to contain_file('/etc/sudoers').with_content(%r{Defaults    group_plugin=\"\/opt\/quest\/lib64\/libsudo_vas.so\"}) }
    end

    describe "on #{os} with libsudo_vas_location set to valid absolute path when include_libsudo_vas is true" do
      let(:params) { { libsudo_vas_location: '/unit/test', include_libsudo_vas: true } }

      it { is_expected.to contain_file('/etc/sudoers').with_content(%r{Defaults    group_plugin=\"\/unit\/test\"}) }
    end

    describe "on #{os} with libsudo_vas_location set to valid absolute path when include_libsudo_vas is false" do
      let(:params) { { libsudo_vas_location: '/unit/test', include_libsudo_vas: false } }

      it { is_expected.to contain_file('/etc/sudoers').without_content(%r{Defaults    group_plugin=}) }
    end

    describe "on #{os} with always_query_group_plugin set to valid true" do
      let(:params) { { always_query_group_plugin: true } }

      it { is_expected.to contain_file('/etc/sudoers').with_content(%r{Defaults    always_query_group_plugin}) }
    end

    describe "on #{os} with always_query_group_plugin set to valid false" do
      let(:params) { { always_query_group_plugin: false } }

      it { is_expected.to contain_file('/etc/sudoers').without_content(%r{Defaults    always_query_group_plugin}) }
    end

    describe "on #{os} with include_libsudo_vas set to valid true and sudo_version fact is >= 1.8.15" do
      let(:params) { { include_libsudo_vas: true } }
      let(:facts) { os_facts.merge({ sudo_version: '1.8.15' }) }

      it { is_expected.to contain_file('/etc/sudoers').with_content(%r{Defaults    always_query_group_plugin}) }
    end

    describe "on #{os} with include_libsudo_vas set to valid true and sudo_version fact is < 1.8.15" do
      let(:params) { { include_libsudo_vas: true } }
      let(:facts) { os_facts.merge({ sudo_version: '1.8.14' }) }

      it { is_expected.to contain_file('/etc/sudoers').without_content(%r{Defaults    always_query_group_plugin}) }
    end
  end
end
