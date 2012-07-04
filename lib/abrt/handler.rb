module ABRT

  def self.handle_exception(exception)
    syslog.notice "detected unhandled Ruby exception in '#{$0}'"

    require 'abrt/exception.rb'
    exception.extend(ABRT::Exception)

    # TODO: Report only scripts with absolute path.

    write_dump exception.format
  end

private

  def self.syslog
    return @syslog if @syslog

    require 'syslog'
    @syslog = Syslog.open 'abrt'
  end

  def self.write_dump(backtrace)
    begin
      require 'socket'

      # TODO: Get var_run from ABRT configuration.
      var_run = "/var/run"
      socket = UNIXSocket.new "#{var_run}/abrt/abrt.socket"

      socket.write "PUT / HTTP/1.1\r\n\r\n"
      socket.write "PID=#{Process.pid}\0"
      socket.write "EXECUTABLE=#{$PROGRAM_NAME}\0"
      # TODO: Do we need specialized Ruby analyzer?
      # socket.write "ANALYZER=Ruby\0"
      socket.write "ANALYZER=Python\0"
      socket.write "BASENAME=rbhook\0"
      socket.write "REASON=#{backtrace.first}\0"
      socket.write "BACKTRACE=#{backtrace.join("\n")}\0"
      socket.close_write

      response = socket.read

      socket.close

      parts = response.split
      code = Integer(parts[1]) rescue false
      if (parts.size < 2) or
        (not parts[0] =~ %r{^HTTP/}) or
        (not code) or
        (code >= 400)
      then
        if response.empty?
          syslog.err "error sending data to ABRT daemon. Empty response received"
        else
          syslog.err "error sending data to ABRT daemon: #{response}"
        end
      end
    rescue StandardError => e
      syslog.err "can't communicate with ABRT daemon, is it running? #{e.message}"
    end
  end
end
