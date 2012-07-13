require 'socket'
require 'syslog'
require 'abrt/exception.rb'

module ABRT

  def self.handle_exception(exception)
    syslog.notice "detected unhandled Ruby exception in '#{$0}'"

    exception.extend(ABRT::Exception)

    # Report only scripts with absolute path.
    write_dump(exception.format) if exception.backtrace.last[0] == '/'
  end

private

  def self.syslog
    @syslog ||= Syslog.open 'abrt'
  end

  def self.report(backtrace, io = abrt_socket)
    io.write "PUT / HTTP/1.1\r\n\r\n"
    io.write "PID=#{Process.pid}\0"
    io.write "EXECUTABLE=#{backtrace.last[/from (.*?):/, 1]}\0"
    io.write "ANALYZER=Ruby\0"
    io.write "BASENAME=rbhook\0"
    io.write "REASON=#{backtrace.first}\0"
    io.write "BACKTRACE=#{backtrace.join("\n")}\0"
    io.close_write

    yield io.read

    io.close
  rescue StandardError => e
    syslog.err "can't communicate with ABRT daemon, is it running? #{e.message}"
  end

  def self.write_dump(backtrace)
    report backtrace do |response|
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
          syslog.err "error sending data to ABRT daemon: #{response}"
        end
      end
    end
  end

  # TODO: Get VAR_RUN from ABRT configuration.
  VAR_RUN = '/var/run'
  ABRT_SOCKET_PATH = File.join VAR_RUN, 'abrt/abrt.socket'

  def self.abrt_socket
    UNIXSocket.new ABRT_SOCKET_PATH
  end

end
