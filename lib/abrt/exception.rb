# This might be removed if http://bugs.ruby-lang.org/issues/6286 gets accepted.

module ABRT
  module Exception
    def format
      backtrace = self.backtrace.collect { |line| "\tfrom #{line}" }
      backtrace[0] = "#{self.backtrace.first}: #{self.message} (#{self.class.name})"
      backtrace
    end
  end
end
