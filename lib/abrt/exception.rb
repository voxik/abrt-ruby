# This might be removed if http://bugs.ruby-lang.org/issues/6286 gets accepted.

module ABRT
  module Exception
    # Provides the exception formated in the same way as Ruby does for standard
    # error output.
    def format
      backtrace = self.backtrace.collect { |line| "\tfrom #{line}" }
      backtrace[0] = "#{self.backtrace.first}: #{self.message} (#{self.class.name})"
      backtrace
    end

    # Obtains executable name from backtrace. This should be more reliable then
    # use of $0 aka $PROGRAM_NAME.
    def executable
      backtrace && backtrace.last && backtrace.last[/(.*?):/, 1] || $PROGRAM_NAME
    end
  end
end
