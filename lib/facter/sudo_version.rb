# Fact: sudo_version
#   returns the version of Sudo
#
# Fact: quest_sudo
#   boolean based on the presence of quest sudo
#
module Facter::Util::SudoVersion
  class << self

    def get_sudo_version
      response = ''
      if File.exists? '/usr/bin/sudo'
        path = '/usr/bin/sudo'
        @questsudo = false
      elsif File.exists? '/opt/quest/bin/sudo'
        path = '/opt/quest/bin/sudo'
        @questsudo = true
      else
        path = ''
      end

      if /\/quest\// =~ path then
        # quest-sudo is used!
        regexp = /^Sudo version +(\S+)q\d+$/
      else
        # sudo is used!
        regexp = /^Sudo version +(\S+)$/
      end

      # Check if path is valid
      if File.exist?(path) then
        cmd = path + ' -V'
        str = Facter::Util::Resolution.exec(cmd)
        if $?.exitstatus == 0 and regexp =~ str then
          response = Regexp.last_match(1)
        end
      end

      response
    end

    def get_quest_sudo
      if File.exists? '/opt/quest/bin/sudo'
        true
      else
        false
      end
    end

  end
end

Facter.add('sudo_version') do
  setcode { Facter::Util::SudoVersion.get_sudo_version }
end

Facter.add('quest_sudo') do
  setcode { Facter::Util::SudoVersion.get_quest_sudo }
end
