# UtilLinuxLogger is small utility class intended to be drop in replacement for
# Syslog. It uses `logger` command from util-linux project to provide system
# logging facilities.
#
# It implements just minimal interface required by ABRT project.
class UtilLinuxLogger
  # :yields: syslog
  #
  # Open the UtilLinuxLoggersyslog facility.
  #
  # `ident` is a String which identifies the calling program.
  def self.open(ident)
    self.new(ident)
  end

  def initialize(ident)
    @ident = ident
  end

  def notice(format_string, *arguments)
    log 'user.notice', format_string, *arguments
  end

  def err(format_string, *arguments)
    log 'user.err', format_string, *arguments
  end

private
  def log(priority, format_string, *arguments)
    IO.popen "logger -p #{priority} -t #{@ident} --socket-errors=off", 'w' do |io|
      io.write sprintf(format_string, *arguments)
    end
  end
end
