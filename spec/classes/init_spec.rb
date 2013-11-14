require 'spec_helper'
describe 'sudo' do
  context 'with class default options' do
    it do
      should contain_package('sudo-package').with({
        'ensure' => 'present',
        'name' => 'sudo',
      })
      should_not contain_file('/etc/sudoers.d')
    end
  end

  context 'with specifying package and config_dir parameters with sudoers hash' do
    let(:params) { {:package           => 'package',
                    :package_ensure    => 'absent',
                    :package_source    => '/file',
                    :package_adminfile => '/adminfile',
                    :config_dir        => '/folder',
                    :config_dir_ensure => 'absent',
                    :config_dir_group  => 'bar',
                    :config_dir_purge  => 'false',
                    :sudoers_manage    => 'true',
                    :sudoers           => { 'root' => { 'content' => 'root ALL=(ALL) ALL' }, 'webusers' => { 'priority' => '20', 'source' => 'puppet:///files/webusers' } },
      } }
    it do
      should contain_package('sudo-package').with({
        'ensure' => 'absent',
        'name'   => 'package',
        'source' => '/file',
        'adminfile' => '/adminfile',
      })
      should contain_file('/folder').with({
        'ensure'  => 'absent',
        'owner'   => 'root',
        'group'   => 'bar',
        'mode'    => '0550',
        'recurse' => 'false',
        'purge'   => 'false',
      })
      should contain_file('10_root').with({
        'ensure'  => 'present',
        'path'    => '/folder/10_root',
        'owner'   => 'root',
        'group'   => 'bar',
        'mode'    => '0440',
        'content' => 'root ALL=(ALL) ALL',
      })
      should contain_file('20_webusers').with({
        'ensure'  => 'present',
        'path'    => '/folder/20_webusers',
        'owner'   => 'root',
        'group'   => 'bar',
        'mode'    => '0440',
        'source'  => 'puppet:///files/webusers',
      })
    end
  end

  context 'with default options and specifying sudoers hash' do
    let(:params) { {:sudoers  => { 'root' => { 'content' => 'root ALL=(ALL) ALL' }, 'webusers' => { 'priority' => '20', 'source' => 'puppet:///files/webusers' } } } }
    it do
      should contain_package('sudo-package').with({
        'ensure' => 'present',
        'name' => 'sudo',
      })
      should_not contain_file('/etc/sudoers.d')
      should_not contain_file('10_root')
      should_not contain_file('20_webusers')
    end
  end

  context 'with specifying sudoers_manage true and sudoers hash' do
    let(:params) { {:sudoers        => { 'root' => { 'content' => 'root ALL=(ALL) ALL' }, 'webusers' => { 'priority' => '20', 'source' => 'puppet:///files/webusers' } },
                    :sudoers_manage => 'true',
    } }
    it do
      should contain_package('sudo-package').with({
        'ensure' => 'present',
        'name' => 'sudo',
      })
      should contain_file('/etc/sudoers.d').with({
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0550',
        'recurse' => 'true',
        'purge'   => 'true',
      })
      should contain_file('10_root').with({
        'ensure'  => 'present',
        'path'    => '/etc/sudoers.d/10_root',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0440',
        'content' => 'root ALL=(ALL) ALL',
      })
      should contain_file('20_webusers').with({
        'ensure'  => 'present',
        'path'    => '/etc/sudoers.d/20_webusers',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0440',
        'source'  => 'puppet:///files/webusers',
      })
    end
  end

  context 'with specifying package_manage param set to invalid value' do
    let(:params) { {:package_manage  => [ true ] } }
    it do
       expect { should }.to raise_error
    end
  end
  context 'with specifying sudoers_manage param set to invalid value' do
    let(:params) { {:sudoers_manage  => 'foo' } }
    it do
       expect { should }.to raise_error
    end
  end
  context 'with specifying config_dir_purge set to invalid value' do
    let(:params) { {:config_dir_purge  => 'invalid' } }
    it do
       expect { should }.to raise_error
    end
  end
  context 'with specifying config_dir set to invalid value' do
    let(:params) { {:config_dir  => 'invalidpath' } }
    it do
       expect { should }.to raise_error
    end
  end
  context 'with specifying adminfile param set to invalid value' do
    let(:params) { {:package_adminfile  => 'invalidpath' } }
    it do
       expect { should }.to raise_error
    end
  end

end
