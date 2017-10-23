# Fact: sudo_version
#   returns the version of Sudo
#
Facter.add('sudo_version') do
  setcode do
    response = 'unknown'

    begin
      path = `which sudo`.strip

      if path.length == 0 or not File.exists?(path)
        raise 'path does not exist'
      end

      regexp = /^Sudo version +(\S+)$/

      result = `#{path} -V`.strip

      if result =~ regexp
        response = Regexp.last_match(1)
      end
    rescue
      response = 'nosudo'
    end

    response
  end
end
