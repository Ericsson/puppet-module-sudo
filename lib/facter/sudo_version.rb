# Fact: sudo_version
#   returns the version string of sudo
#
# Fact: quest_sudo
#   boolean based on the presence of quest sudo
#
# Fact: sudo_version_numeric
#   string that returns the numeric part of the version string of sudo
#
module SudoVersion
  def self.fetch_sudo_path
    if File.exist? '/opt/quest/bin/sudo'
      '/opt/quest/bin/sudo'
    else
      Facter::Util::Resolution.which('sudo')
    end
  end

  def self.fetch_quest_sudo
    SudoVersion.fetch_sudo_path =~ %r{/quest/} ? true : false
  end

  def self.fetch_sudo_version
    if SudoVersion.fetch_quest_sudo == true
      Facter::Util::Resolution.exec(SudoVersion.fetch_sudo_path + ' -V 2>&1')[/^Sudo version +(\S+)q\d+$/, 1]
    else
      Facter::Util::Resolution.exec(SudoVersion.fetch_sudo_path + ' -V 2>&1')[/^Sudo version +(\S+)$/, 1]
    end
  end

  def self.add_facts
    Facter.add('sudo_version') do
      setcode { SudoVersion.fetch_sudo_path && SudoVersion.fetch_sudo_version }
    end

    Facter.add('quest_sudo') do
      setcode { SudoVersion.fetch_quest_sudo }
    end

    Facter.add('sudo_version_numeric') do
      setcode { Facter.value(:sudo_version).match(/(\d+\.\d+\.\d+|\d+\.\d+)/)[0] }
    end
  end
end

SudoVersion.add_facts
