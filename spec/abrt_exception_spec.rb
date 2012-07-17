require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'abrt/exception'

describe "ABRT::Exception" do
  let(:exception) do
    RuntimeError.new("baz").tap do |e|
      e.set_backtrace([
        "/foo/bar.rb:3:in `block in func'",
        "/foo/bar.rb:2:in `each'",
        "/foo/bar.rb:2:in `func'",
        "/foo.rb:2:in `<main>'"
      ])
      e.extend(ABRT::Exception)
    end
  end

  describe "#format" do
    it "provides the formated exception message" do
      exception.format.should == [
        "/foo/bar.rb:3:in `block in func': baz (RuntimeError)",
          "\tfrom /foo/bar.rb:2:in `each'",
          "\tfrom /foo/bar.rb:2:in `func'",
          "\tfrom /foo.rb:2:in `<main>'"
      ]
    end
  end

  describe "#executable" do
    it "gets executable from backtrace" do
      exception.executable.should == "/foo.rb"
    end
  end

end
