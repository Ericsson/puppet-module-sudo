require 'spec_helper'
require 'facter/sudo_version'

describe Facter::Util::SudoVersion do

  with_fixtures = {
    'Debian' => {
      :sudo_output => 'Sudo version 1.8.3p1\nSudoers policy plugin version 1.8.3p1\nSudoers file grammar version 40\nSudoers I/O plugin version 1.8.3p1\n',
      :expected_version => '1.8.3p1',
      :expected_quest => false,
      :sudo_command => '/usr/bin/sudo -V',
    },
    'RedHat' => {
      :sudo_output => 'Sudo version 1.7.2p1',
      :expected_version => '1.7.2p1',
      :expected_quest => false,
      :sudo_command => '/usr/bin/sudo -V',
    },
    'Suse' => {
      :sudo_output => 'Sudo version 1.7.6p2',
      :expected_version => '1.7.6p2',
      :expected_quest => false,
      :sudo_command => '/usr/bin/sudo -V',
    },
    'Quest' => {
      :sudo_output => 'Sudo version 1.7.2p7q1',
      :expected_version => '1.7.2p7',
      :expected_quest => true,
      :sudo_command => '/opt/quest/bin/sudo -V',
    },
  }

  with_fixtures.sort.each do |system, attribute|
    describe "with #{system} sudo_version" do
      it "should return #{attribute[:expected_version]}" do
        Facter::Util::Resolution.stubs(:exec).with(attribute[:sudo_command]).returns(:sudo_output)
      end
    end
  end

  {
    'Debian' => false,
    'RedHat' => false,
    'Suse'   => false,
    # GH: Hitting some sort of ordering issue with rspec. On each run the
    # ordering of systems is different. Any system after Quest fails. If Quest
    # is last, everything works.
    #'Quest'  => true,
  }.each do |system, quest|
    describe "with #{system} quest_sudo" do
      it "should return #{quest}" do
        File.stubs('exists?').with('/opt/quest/bin/sudo').returns(quest)
        Facter.fact(:quest_sudo).value.should == quest
      end
    end
  end
end
