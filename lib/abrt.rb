at_exit do
  if $! && !($!.is_a? SystemExit)
    require 'abrt/handler'
    ABRT.handle_exception($!)
  end
end

# Test drive the gem.
if File.identical?(__FILE__, $0)
  [1, 2, 3].freeze << 4
end
