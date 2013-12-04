# sudo_version

if File.exists? '/opt/quest/bin/sudo'
  path = '/opt/quest/bin/sudo'
  questsudo = true
else
  path = '/usr/bin/sudo'
  questsudo = false
end

Facter.add("sudo_version") do
  setcode do
    response = ''

    if /\/quest\// =~ path then
      # quest-sudo is used!
      regexp = /^Sudo version +(\S+)q\d+$/
    else
      # sudo is used!
      regexp = /^Sudo version +(\S+)$/
    end

    # Check if path is valid
    if File.exist?( path ) then
      cmd = path + ' -V'
      str = Facter::Util::Resolution.exec( cmd )
      if $?.exitstatus == 0 and regexp =~ str then
        response = Regexp.last_match(1)
      end
    end

    response # Return
  end
end

Facter.add("quest_sudo") do
  setcode do
    questsudo
  end
end

