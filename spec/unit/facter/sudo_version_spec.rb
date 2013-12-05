require 'spec_helper'
#require 'facter'
require 'facter/sudo_version'

describe Facter::Util::SudoVersion do
  context 'debian' do
    let(:sudo_output) { "Sudo version 1.8.3p1\nSudoers policy plugin version 1.8.3p1\nSudoers file grammar version 40\nSudoers I/O plugin version 1.8.3p1\n" }
    let(:expected_version) { "1.8.3p1" }
    let(:expected_quest) { false }

    it "should return 1.8.3p1" do
      Facter::Util::Resolution.expects(:exec).with("/usr/bin/sudo -V").returns(sudo_output)
      Facter::Util::SudoVersion.get_sudo_version.should == expected_version
      Facter::Util::SudoVersion.get_quest_sudo.should == expected_quest
    end
  end
  context 'redhat' do
    let(:sudo_output) { "Sudo version 1.7.2p1" }
    let(:expected_version) { "1.7.2p1" }
    let(:expected_quest) { false }

    it "should return 1.7.2p1" do
      Facter::Util::Resolution.expects(:exec).with("/usr/bin/sudo -V").returns(sudo_output)
      Facter::Util::SudoVersion.get_sudo_version.should == expected_version
      Facter::Util::SudoVersion.get_quest_sudo.should == expected_quest
    end
  end
  context 'suse' do
    let(:sudo_output) { "Sudo version 1.7.6p2" }
    let(:expected_version) { "1.7.6p2" }
    let(:expected_quest) { false }

    it "should return 1.7.6p2" do
      Facter::Util::Resolution.expects(:exec).with("/usr/bin/sudo -V").returns(sudo_output)
      Facter::Util::SudoVersion.get_sudo_version.should == expected_version
      Facter::Util::SudoVersion.get_quest_sudo.should == expected_quest
    end
  end
  context 'quest' do
    let(:sudo_output) { "Sudo version 1.7.2p7q1" }
    let(:expected_version) { "1.7.2p7" }
    let(:expected_quest) { true }

    it "should return 1.7.2p7" do
      Facter::Util::Resolution.expects(:exec).with("/opt/quest/bin/sudo -V").returns(sudo_output)
      Facter::Util::SudoVersion.get_sudo_version.should == expected_version
      Facter::Util::SudoVersion.get_quest_sudo.should == expected_quest
    end
  end
end
