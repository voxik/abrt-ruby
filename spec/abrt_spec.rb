require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'ABRT' do
  context "handles exception in 'abrt.rb' with RubyGems" do
    abrt_rb = File.join(File.dirname(__FILE__), '../lib/abrt.rb')
    output_message_pattern = /\A#{abrt_rb}:\d+:in `<main>': can't modify frozen Array(: \[1, 2, 3\])? \((FrozenError|RuntimeError)\)\n\Z/

    it 'disabled' do
      expect { system "ruby --disable-gems #{abrt_rb}" }
        .to output(/\A\Z/).to_stdout_from_any_process
        .and output(output_message_pattern).to_stderr_from_any_process
    end

    it 'enabled' do
      expect { system "ruby --disable-gems -rrubygems #{abrt_rb}" }
        .to output(/\A\Z/).to_stdout_from_any_process
        .and output(output_message_pattern).to_stderr_from_any_process
    end
  end
end
