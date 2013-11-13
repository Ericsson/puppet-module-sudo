require 'spec_helper'
describe 'sudo' do

  describe 'package' do

    context 'with class default options' do
      it do
        should contain_package('sudo-package').with({
          'ensure' => 'present',
          'name' => 'sudo',
        })
      end
    end
    context 'with specifying package parameters' do
      let(:params) { {:package        => 'foo',
                      :package_ensure => 'absent',
                      :package_source => '/file',
        } }
      it do
        should contain_package('sudo-package').with({
          'ensure' => 'absent',
          'name'   => 'foo',
          'source' => '/file',
        })
      end
    end

  end

  describe 'sudoers' do

    context 'with class default options' do
      it do
        should_not contain_file('/etc/sudoers.d')
      end
    end
    context 'with specifying manage config dir' do
      let(:params) { {:sudoers_manage => 'true' } }
      it do
        should contain_file('/etc/sudoers.d').with({
          'ensure'  => 'present',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0550',
          'recurse' => 'true',
          'purge'   => 'true',
        })
      end
    end
    context 'with specifying config dir parameters' do
      let(:params) { {:config_dir        => '/foo',
                      :config_dir_ensure => 'absent',
                      :config_dir_group  => 'bar',
                      :config_dir_purge  => 'false',
                      :sudoers_manage    => 'true',
        } }
      it do
        should contain_file('/foo').with({
          'ensure'  => 'absent',
          'owner'   => 'root',
          'group'   => 'bar',
          'mode'    => '0550',
          'recurse' => 'false',
          'purge'   => 'false',
        })
      end
    end
    context 'with specifying sudoers hash' do
      let(:params) { {:sudoers        => { 'root' => { 'content' => 'root ALL=(ALL) ALL' }, 'webusers' => { 'priority' => '20', 'source' => 'puppet:///files/webusers' } },
                      :sudoers_manage => 'true',
                      :config_dir     => '/folder',
        } }
      it do
        should contain_file('10_root').with({
          'ensure'  => 'present',
          'path'    => '/folder/10_root',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0440',
          'content' => 'root ALL=(ALL) ALL',
        })
        should contain_file('20_webusers').with({
          'ensure'  => 'present',
          'path'    => '/folder/20_webusers',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0440',
          'source'  => 'puppet:///files/webusers',
        })
      end
    end
  end
end
