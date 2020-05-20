require 'socket'
require 'syslog'
require_relative 'exception'

module ABRT

  def self.handle_exception(exception)
    exception.extend(ABRT::Exception)

    syslog.notice "detected unhandled Ruby exception in '#{exception.executable}'"

    # Report only scripts with absolute path.
    write_dump(exception) if exception.executable[0, 1] == '/'
  end

private

  def self.syslog
    @syslog ||= Syslog.open 'abrt'
  end

  def self.report(exception, io = nil)
    io ||= abrt_socket

    io.write "PUT / HTTP/1.1\r\n\r\n"
    io.write "PID=#{Process.pid}\0"
    io.write "EXECUTABLE=#{exception.executable.gsub(/\u0000/, '')}\0"
    io.write "ANALYZER=Ruby\0"
    io.write "TYPE=Ruby\0"
    io.write "BASENAME=rbhook\0"
    io.write "REASON=#{exception.format.first.gsub(/\u0000/, '')}\0"
    io.write "BACKTRACE=#{exception.format.join("\n").gsub(/\u0000/, '')}\0"
    io.close_write

    yield io.read

    io.close
  rescue StandardError => e
    syslog.err "%s", "can't communicate with ABRT daemon, is it running? #{e.message}"
  end

  def self.write_dump(exception)
    report exception do |response|
      if response.empty?
        syslog.err "error sending data to ABRT daemon. Empty response received"
      else
        parts = response.split
        code = Integer(parts[1]) rescue false
        if (parts.size < 2) or
          (not parts[0] =~ %r{^HTTP/}) or
          (not code) or
          (code >= 400)
        then
          syslog.err "%s", "error sending data to ABRT daemon: #{response}"
        end
      end
    end
  end

  # TODO: Get VAR_RUN from ABRT configuration.
  VAR_RUN = '/var/run'
  ABRT_SOCKET_PATH = File.join VAR_RUN, 'abrt/abrt.socket'

  def self.abrt_socket(path = ABRT_SOCKET_PATH)
    UNIXSocket.new path
  end

end
