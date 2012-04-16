module ABRT
  module Exception
    def format
      backtrace = self.backtrace.dup
      backtrace[0] += ": #{self.message} (#{self.class.name})"
      backtrace.join "\n\tfrom "
    end
  end
end
