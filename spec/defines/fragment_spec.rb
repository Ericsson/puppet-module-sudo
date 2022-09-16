require 'spec_helper'
describe 'sudo::fragment', type: :define do
  let(:title) { 'testing' }
  let(:pre_condition) do
    'include sudo'
  end

  on_supported_os.sort.each do |os, os_facts|
    describe "on #{os} with default values for parameters" do
      let(:facts) { os_facts }

      it { is_expected.to contain_class('sudo') }
      it { is_expected.to contain_file('/etc/sudoers.d') }  # only needed for 100% resource coverage
      it { is_expected.to contain_file('/etc/sudoers') }    # only needed for 100% resource coverage
      it { is_expected.to contain_package('sudo-package') } # only needed for 100% resource coverage

      it do
        is_expected.to contain_file('10_testing').only_with(
          {
            'ensure'  => 'present',
            'path'    => '/etc/sudoers.d/10_testing',
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0440',
            'source'  => nil,
            'content' => nil,
          },
        )
      end
    end

    describe "on #{os} with ensure set to valid string <absent>" do
      let(:params) { { ensure: 'absent' } }

      it { is_expected.to contain_file('10_testing').with_ensure('absent') }
    end

    describe "on #{os} with priority set to valid integer <3>" do
      let(:params) { { priority: 3 } }

      it { is_expected.to contain_file('3_testing') }
    end

    describe "on #{os} with content set to valid string <testing>" do
      let(:params) { { content: 'testing' } }

      it { is_expected.to contain_file('10_testing').with_content("testing\n") }
    end

    describe "on #{os} with source set to valid Stdlib::Filesource </test/ing>" do
      let(:params) { { source: '/test/ing' } }

      it { is_expected.to contain_file('10_testing').with_source('/test/ing') }
    end

    describe "on #{os} with config_dir set to valid Stdlib::Absolutepath </test/ing>" do
      let(:params) { { config_dir: '/test/ing' } }

      it { is_expected.to contain_file('10_testing').with_path('/test/ing/10_testing') }
    end

    describe "on #{os} with config_dir_group set to valid string <testing>" do
      let(:params) { { config_dir_group: 'testing' } }

      it { is_expected.to contain_file('10_testing').with_group('testing') }
    end
  end
end
