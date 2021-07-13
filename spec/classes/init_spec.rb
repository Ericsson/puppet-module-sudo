require 'spec_helper'
describe 'sudo' do
  default_facts = {
    architecture: 'x86_64',
    sudo_version: '1.8.6p7'
  }

  let(:facts) { default_facts }

  context 'with class default options' do
    it do
      is_expected.to contain_package('sudo-package').with(
        {
          'ensure' => 'present',
          'name'   => 'sudo',
        },
      )
      is_expected.to contain_file('/etc/sudoers.d').with(
        {
          'ensure'  => 'directory',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0750',
          'recurse' => 'true',
          'purge'   => 'true',
        },
      )
      is_expected.to contain_file('/etc/sudoers').with(
        {
          'owner' => 'root',
          'group' => 'root',
          'mode'  => '0440',
        },
      )
      is_expected.to contain_file('/etc/sudoers').with_content(%r{^Defaults    requiretty$})
      is_expected.to contain_file('/etc/sudoers').with_content(%r{^Defaults    !visiblepw$})
      is_expected.to contain_file('/etc/sudoers').with_content(%r{^Defaults    always_set_home$})
      is_expected.to contain_file('/etc/sudoers').with_content(%r{^Defaults    env_reset$})
      # rubocop:disable LineLength
      is_expected.to contain_file('/etc/sudoers').with_content(%r{^Defaults    env_keep = "COLORS DISPLAY HOSTNAME HISTSIZE INPUTRC KDEDIR LS_COLORS MAIL PS1 PS2 QTDIR USERNAME LANG LC_ADDRESS LC_CTYPE LC_COLLATE LC_IDENTIFICATION LC_MEASUREMENT LC_MESSAGES LC_MONETARY LC_NAME LC_NUMERIC LC_PAPER LC_TELEPHONE LC_TIME LC_ALL LANGUAGE LINGUAS _XKB_CHARSET XAUTHORITY"$})
      # rubocop:enable LineLength
      is_expected.to contain_file('/etc/sudoers').with_content(%r{^Defaults    secure_path = \/sbin:\/bin:\/usr\/sbin:\/usr\/bin$})
      is_expected.to contain_file('/etc/sudoers').with_content(%r{^root  ALL=\(ALL\)   ALL$})
      is_expected.to contain_file('/etc/sudoers').with_content(%r{^#includedir \/etc\/sudoers.d$})
      is_expected.not_to contain_file('/etc/sudoers').with_content(%r{^Defaults    always_query_group_plugin$})
    end
  end

  context 'with all options set and manage all resources' do
    let(:params) do
      {
        package:              'package',
        package_ensure:       'absent',
        package_source:       '/file',
        package_adminfile:    '/adminfile',
        package_manage:       'true',
        config_dir:           '/folder',
        config_dir_ensure:    'absent',
        config_dir_mode:      '0550',
        config_dir_group:     'bar',
        config_dir_purge:     'false',
        sudoers_manage:       'true',
        sudoers:              { 'root' => { 'content' => 'root ALL=(ALL) ALL' }, 'webusers' => { 'priority' => '20', 'source' => 'puppet:///files/webusers' } },
        config_file:          '/sudoers/file',
        config_file_group:    'group',
        config_file_owner:    'owner',
        config_file_mode:     '1555',
        requiretty:           'false',
        visiblepw:            'true',
        always_set_home:      'false',
        envreset:             'false',
        envkeep:              ['VARIABLE'],
        secure_path:          '/folder',
        root_allow_all:       'false',
        includedir:           'false',
        include_libsudo_vas:  'true',
        libsudo_vas_location: '/folder/file.so',
      }
    end

    it do
      is_expected.to contain_package('sudo-package').with(
        {
          'ensure'    => 'absent',
          'name'      => 'package',
          'source'    => '/file',
          'adminfile' => '/adminfile',
        },
      )
      is_expected.to contain_file('/folder').with(
        {
          'ensure'  => 'absent',
          'owner'   => 'root',
          'group'   => 'bar',
          'mode'    => '0550',
          'recurse' => 'false',
          'purge'   => 'false',
        },
      )
      is_expected.to contain_file('10_root').with(
        {
          'ensure'  => 'present',
          'path'    => '/folder/10_root',
          'owner'   => 'root',
          'group'   => 'bar',
          'mode'    => '0440',
          'content' => "root ALL=(ALL) ALL\n",
        },
      )
      is_expected.to contain_file('20_webusers').with(
        {
          'ensure' => 'present',
          'path'   => '/folder/20_webusers',
          'owner'  => 'root',
          'group'  => 'bar',
          'mode'   => '0440',
          'source' => 'puppet:///files/webusers',
        },
      )
      is_expected.to contain_file('/sudoers/file').with(
        {
          'owner' => 'owner',
          'group' => 'group',
          'mode'  => '1555',
        },
      )
      is_expected.to contain_file('/sudoers/file').with_content(%r{^Defaults    !requiretty$})
      is_expected.to contain_file('/sudoers/file').with_content(%r{^Defaults    visiblepw$})
      is_expected.to contain_file('/sudoers/file').with_content(%r{^Defaults    !always_set_home$})
      is_expected.to contain_file('/sudoers/file').with_content(%r{^Defaults    !env_reset$})
      is_expected.to contain_file('/sudoers/file').with_content(%r{^Defaults    env_keep = \"VARIABLE\"$})
      is_expected.to contain_file('/sudoers/file').with_content(%r{^Defaults    secure_path = \/folder$})
      is_expected.not_to contain_file('/sudoers/file').with_content(%r{^root  ALL=\(ALL\)   ALL\n$})
      is_expected.not_to contain_file('/sudoers/file').with_content(%r{^#includedir \/folder$})
      is_expected.to contain_file('/sudoers/file').with_content(%r{^Defaults    group_plugin=\"\/folder\/file.so\"$})
    end
  end

  context 'with default options and package_manage false' do
    let(:params) { { package_manage: 'false' } }

    it do
      is_expected.to contain_file('/etc/sudoers.d').with(
        {
          'ensure'  => 'directory',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0750',
          'recurse' => 'true',
          'purge'   => 'true',
        },
      )
      is_expected.to contain_file('/etc/sudoers').with(
        {
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0440',
        },
      )
      is_expected.not_to contain_package('sudo-package')
    end
  end

  context 'with default options and sudoers_manage false' do
    let(:params) { { sudoers_manage: 'false' } }

    it do
      is_expected.to contain_package('sudo-package').with(
        {
          'ensure' => 'present',
          'name'   => 'sudo',
        },
      )
      is_expected.not_to contain_file('/etc/sudoers.d')
      is_expected.not_to contain_file('/etc/sudoers')
    end
  end

  context 'with sudoers_manage and package_manage false and with sudoers hash' do
    let(:params) do
      {
        sudoers:        { 'root' => { 'content' => 'root ALL=(ALL) ALL' }, 'webusers' => { 'priority' => '20', 'source' => 'puppet:///files/webusers' } },
        sudoers_manage: 'false',
        package_manage: 'false',
      }
    end

    it do
      is_expected.not_to contain_package('sudo-package')
      is_expected.not_to contain_file('/etc/sudoers.d')
      is_expected.not_to contain_file('/etc/sudoers')
      is_expected.not_to contain_file('10_root')
      is_expected.not_to contain_file('20_webusers')
    end
  end

  context 'with default options and include_libsudo_vas set to true on Linux x86_64' do
    let(:params) { { include_libsudo_vas: true, } }

    it do
      is_expected.to contain_file('/etc/sudoers').with_content(%r{^Defaults    group_plugin=\"\/opt\/quest\/lib64\/libsudo_vas.so\"$})
    end
  end

  context 'with default options and include_libsudo_vas set to true on Linux amd64' do
    let :facts do
      default_facts.merge(
        {
          architecture: 'amd64',
        },
      )
    end

    let(:params) { { include_libsudo_vas: true, } }

    it do
      is_expected.to contain_file('/etc/sudoers').with_content(%r{^Defaults    group_plugin=\"\/opt\/quest\/lib64\/libsudo_vas.so\"$})
    end
  end

  context 'with default options and include_libsudo_vas set to true on Linux i686' do
    let :facts do
      default_facts.merge(
        {
          architecture: 'i686',
        },
      )
    end

    let(:params) { { include_libsudo_vas: true, } }

    it do
      is_expected.to contain_file('/etc/sudoers').with_content(%r{^Defaults    group_plugin=\"\/opt\/quest\/lib\/libsudo_vas.so\"$})
    end
  end

  context 'with default options and include_libsudo_vas set to true on SunOS sun4v' do
    let :facts do
      default_facts.merge(
        {
          architecture: 'sun4v',
        },
      )
    end

    let(:params) { { include_libsudo_vas: true, } }

    it do
      is_expected.to contain_file('/etc/sudoers').with_content(%r{^Defaults    group_plugin=\"\/opt\/quest\/lib\/libsudo_vas.so\"$})
    end
  end

  context 'with default options and include_libsudo_vas set to true on SunOS i86pc' do
    let :facts do
      default_facts.merge(
        {
          architecture: 'i86pc',
        },
      )
    end

    let(:params) { { include_libsudo_vas: true, } }

    it do
      is_expected.to contain_file('/etc/sudoers').with_content(%r{^Defaults    group_plugin=\"\/opt\/quest\/lib\/libsudo_vas.so\"$})
    end
  end

  describe 'with always query_group_plugin' do
    context 'using module default and sudo_version returns 1.8.15' do
      let(:facts) { default_facts.merge(sudo_version: '1.8.15') }

      it do
        is_expected.not_to contain_file('/etc/sudoers').with_content(%r{^Defaults    always_query_group_plugin$})
      end
    end

    context 'using module default with include_libsudo_vas set to true and sudo_version returns 1.8.6' do
      it do
        is_expected.not_to contain_file('/etc/sudoers').with_content(%r{^Defaults    always_query_group_plugin$})
      end
    end

    context 'using module default with include_libsudo_vas set to true and sudo_version returns 1.8.15' do
      let(:facts) { default_facts.merge(sudo_version: '1.8.15') }
      let(:params) { { include_libsudo_vas: true } }

      it do
        is_expected.to contain_file('/etc/sudoers').with_content(%r{^Defaults    always_query_group_plugin$})
      end
    end

    context 'set to true' do
      let(:params) { { always_query_group_plugin: true } }

      it do
        is_expected.to contain_file('/etc/sudoers').with_content(%r{^Defaults    always_query_group_plugin$})
      end
    end
  end

  context 'with specifying package_manage param set to invalid value' do
    let(:params) { { package_manage: [ true ] } }

    it do
      expect {
        is_expected.to contain_class('sudo')
      }.to raise_error(Puppet::Error, %r{is not a boolean})
    end
  end

  context 'with specifying sudoers_manage param set to invalid value' do
    let(:params) { { sudoers_manage: 'foo' } }

    it do
      expect {
        is_expected.to contain_class('sudo')
      }.to raise_error(Puppet::Error, %r{Unknown type})
    end
  end

  context 'with specifying config_dir_purge set to invalid value' do
    let(:params) { { config_dir_purge: 'invalid' } }

    it do
      expect {
        is_expected.to contain_class('sudo')
      }.to raise_error(Puppet::Error, %r{Unknown type})
    end
  end

  context 'with specifying config_dir set to invalid value' do
    let(:params) { { config_dir: 'invalidpath' } }

    it do
      expect {
        is_expected.to contain_class('sudo')
      }.to raise_error(Puppet::Error, %r{is not an absolute path})
    end
  end

  context 'with specifying config_file param set to invalid value' do
    let(:params) { { config_file: 'invalidpath' } }

    it do
      expect {
        is_expected.to contain_class('sudo')
      }.to raise_error(Puppet::Error, %r{is not an absolute path})
    end
  end

  context 'with specifying adminfile param set to invalid value' do
    let(:params) { { package_adminfile: 'invalidpath' } }

    it do
      expect {
        is_expected.to contain_class('sudo')
      }.to raise_error(Puppet::Error, %r{is not an absolute path})
    end
  end

  context 'with specifying sudoers hash set to invalid value' do
    let(:params) { { sudoers: [ 'not_a_hash' ] } }

    it do
      expect {
        is_expected.to contain_class('sudo')
      }.to raise_error(Puppet::Error, %r{is not a Hash})
    end
  end

  context 'with specifying requiretty set to invalid value' do
    let(:params) { { requiretty: [ 'not_a_bool' ] } }

    it do
      expect {
        is_expected.to contain_class('sudo')
      }.to raise_error(Puppet::Error, %r{is not a boolean})
    end
  end

  context 'with specifying visiblepw set to invalid value' do
    let(:params) { { visiblepw: [ 'not_a_bool' ] } }

    it do
      expect {
        is_expected.to contain_class('sudo')
      }.to raise_error(Puppet::Error, %r{is not a boolean})
    end
  end

  context 'with specifying always_set_home set to invalid value' do
    let(:params) { { always_set_home: [ 'not_a_bool' ] } }

    it do
      expect {
        is_expected.to contain_class('sudo')
      }.to raise_error(Puppet::Error, %r{is not a boolean})
    end
  end

  context 'with specifying envreset set to invalid value' do
    let(:params) { { envreset: [ 'not_a_bool' ] } }

    it do
      expect {
        is_expected.to contain_class('sudo')
      }.to raise_error(Puppet::Error, %r{is not a boolean})
    end
  end

  context 'with specifying envkeep set to invalid value' do
    let(:params) { { envkeep: false } }

    it do
      expect {
        is_expected.to contain_class('sudo')
      }.to raise_error(Puppet::Error, %r{is not an Array})
    end
  end

  context 'with specifying secure_path set to invalid value' do
    let(:params) { { secure_path: [ 'not_a_string' ] } }

    it do
      expect {
        is_expected.to contain_class('sudo')
      }.to raise_error(Puppet::Error, %r{is not a string})
    end
  end

  context 'with specifying root_allow_all set to invalid value' do
    let(:params) { { root_allow_all: [ 'not_a_bool' ] } }

    it do
      expect {
        is_expected.to contain_class('sudo')
      }.to raise_error(Puppet::Error, %r{is not a boolean})
    end
  end

  context 'with specifying includedir to invalid value' do
    let(:params) { { includedir: [ 'not_a_bool' ] } }

    it do
      expect {
        is_expected.to contain_class('sudo')
      }.to raise_error(Puppet::Error, %r{is not a boolean})
    end
  end

  context 'with specifying include_libsudo_vas to invalid value' do
    let(:params) { { include_libsudo_vas: [ 'not_a_bool' ] } }

    it do
      expect {
        is_expected.to contain_class('sudo')
      }.to raise_error(Puppet::Error, %r{is not a boolean})
    end
  end

  context 'with specifying libsudo_vas_location to invalid value' do
    let(:params) do
      {
        libsudo_vas_location: [ 'not_an_absolute_path' ],
        include_libsudo_vas:  true,
      }
    end

    it do
      expect {
        is_expected.to contain_class('sudo')
      }.to raise_error(Puppet::Error, %r{is not an absolute path})
    end
  end

  context 'with specifying hiera_merge_sudoers to invalid value' do
    let(:params) { { hiera_merge_sudoers: 'invalid' } }

    it do
      expect {
        is_expected.to contain_class('sudo')
      }.to raise_error(Puppet::Error, %r{Unknown type of boolean given})
    end
  end
end
