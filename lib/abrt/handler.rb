module ABRT
  require 'abrt/exception'
  require 'socket'
  require 'syslog'

  # TODO: Get var_run from ABRT configuration.
  ABRT_SOCKET_PATH = '/var/run/abrt/abrt.socket'

  def self.handle_exception(exception)
    last_exception = $!

    report_error "detected unhandled Ruby exception in '#{$0}'", :notice

    last_exception.extend(ABRT::Exception)

    # TODO: Report only scripts with absolute path.
    write_dump(last_exception.format)
  end

private

  def self.syslog
    @syslog ||= Syslog.open('abrt')
  end

  def self.report_error(msg, facility=:err)
    syslog.send :facility, msg
  end

  def self.write_to_socket(backtrace)
    UNIXSocket.open(ABRT_SOCKET_PATH) do |socket|
      socket.write "PUT / HTTP/1.1\r\n\r\n"
      socket.write "PID=#{Process.pid}\0"
      socket.write "EXECUTABLE=#{$PROGRAM_NAME}\0"
      # TODO: Do we need specialized Ruby analyzer?
      # socket.write "ANALYZER=Ruby\0"
      socket.write "ANALYZER=Python\0"
      socket.write "BASENAME=rbhook\0"
      socket.write "REASON=#{backtrace.first}\0"
      socket.write "BACKTRACE=#{backtrace}\0"
      yield socket.read
    end
  end

  def self.write_dump(backtrace)
    unless File.exists(file) && File.socket?(file)
      raise 'Cannot open connection to ABRT daemon (%s)' % ABRT_SOCKET_PATH
    end

    write_to_socket(backtrace) do |response|
      report_error('Empty response from the ABRT daemon') if response.empty?

      parts = response.split
      code = parts[1].to_i rescue false

      if (parts.size < 2) or (not parts[0] =~ /^HTTP/) or (not code) or (code >= 400)
        syslog.err "error sending data to ABRT daemon: #{response}"
      end
    end
  end
end
