# Fact: sudo_version
#   returns the version of Sudo
#
Facter.add('sudo_version') do
  setcode do
    response = 'unknown'

    begin
      path = `which sudo`.strip

      if path.empty? || !File.exist?(path)
        raise 'path does not exist'
      end

      regexp = %r{^Sudo version +(\S+)$}

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
