at_exit do
  # Do not report every exception:
  #   SystemExit - raised by Kernel#exit call
  #   Interrupt - typically issued because the user pressed Ctrl+C
  if $! and ![SystemExit, Interrupt].include?($!.class)
    require File.join(File.dirname(__FILE__), 'abrt/handler')
    ABRT.handle_exception($!)
  end
end

# Test drive the gem.
if File.identical?(__FILE__, $0)
  [1, 2, 3].freeze << 4
end
