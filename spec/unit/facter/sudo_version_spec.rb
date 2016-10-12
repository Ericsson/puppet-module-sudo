require 'spec_helper'
require 'facter/sudo_version'

describe 'sudo_version facts' do
  subject(:fact) { Facter.fact(:sudo_version) }

  before :each do
    # Ensure we're populating Facter's internal collection with our Fact
    SudoVersion.add_facts
  end

  with_fixtures = {
    'Debian' => {
      :sudo_command     => '/usr/bin/sudo',
      :sudo_output      => "Sudo version 1.8.3p1\nSudoers policy plugin version 1.8.3p1\nSudoers file grammar version 40\nSudoers I/O plugin version 1.8.3p1\n",
      :expected_version => '1.8.3p1',
      :expected_numeric => '1.8.3',
      :expected_quest   => false,
    },
    'RedHat' => {
      :sudo_command     => '/usr/bin/sudo',
      :sudo_output      => "Sudo version 1.8.6p7\nConfigure options: --build=x86_64-redhat-linux-gnu\nSudoers policy plugin version 1.8.6p7\nSudoers file grammar version 42\n",
      :expected_version => '1.8.6p7',
      :expected_numeric => '1.8.6',
      :expected_quest   => false,
    },
    'Solaris' => {
      :sudo_command     => '/usr/bin/sudo',
      :sudo_output      => "Sudo version 1.8.6p7\nConfigure options: CC=/ws/on11update-tools/SUNWspro/sunstudio12.1/bin/cc\nSudoers policy plugin version 1.8.6p7\nSudoers file grammar version 42\n",
      :expected_version => '1.8.6p7',
      :expected_numeric => '1.8.6',
      :expected_quest   => false,
    },
    'Suse' => {
      :sudo_command     => '/usr/bin/sudo',
      :sudo_output      => "Sudo version 1.8.14p3\nSudoers policy plugin version 1.8.14p3\nSudoers file grammar version 44\nSudoers I/O plugin version 1.8.14p3\n",
      :expected_version => '1.8.14p3',
      :expected_numeric => '1.8.14',
      :expected_quest   => false,
    },
    'Quest' => {
      :sudo_command     => '/opt/quest/bin/sudo',
      :sudo_output      => 'Sudo version 1.7.2p7q1',
      :expected_version => '1.7.2p7',
      :expected_numeric => '1.7.2',
      :expected_quest   => true,
    },
  }

  with_fixtures.sort.each do |system, v|
    describe "on #{system}" do
      it "sudo_version should return #{v[:expected_version]}" do
        Facter::Util::Resolution.stubs(:which).returns(v[:sudo_command])
        Facter::Util::Resolution.stubs(:exec).with(v[:sudo_command] + ' -V 2>&1').returns(v[:sudo_output])
        expect(Facter.fact(:sudo_version).value).to eq(v[:expected_version])
      end
      it "sudo_version_numeric should return #{v[:expected_numeric]}" do
        Facter::Util::Resolution.stubs(:which).returns(v[:sudo_command])
        Facter::Util::Resolution.stubs(:exec).with(v[:sudo_command] + ' -V 2>&1').returns(v[:sudo_output])
        expect(Facter.fact(:sudo_version_numeric).value).to eq(v[:expected_numeric])
      end
      it "quest_sudo should return #{v[:expected_quest]}" do
        Facter::Util::Resolution.stubs(:which).returns(v[:sudo_command])
        expect(Facter.fact(:quest_sudo).value).to eq(v[:expected_quest])
      end
    end
  end

  after :each do
    # Make sure we're clearing out Facter every time
    Facter.clear
    Facter.clear_messages
  end
end
