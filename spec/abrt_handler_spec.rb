require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'abrt/handler'

describe "ABRT" do
  describe "#handle_exception" do
    let(:exception) do
      RuntimeError.new("baz").tap do |e|
        e.set_backtrace([
          "/foo/bar.rb:3:in `block in func'",
          "/foo/bar.rb:2:in `each'",
          "/foo/bar.rb:2:in `func'",
          "/foo.rb:2:in `<main>'"
        ])
      end
    end

    let(:exception_report) do
      "PUT / HTTP/1.1\r\n\r\n" +
      "PID=#{Process.pid}\u0000" +
      "EXECUTABLE=/foo.rb\u0000" +
      "ANALYZER=Ruby\u0000" +
      "TYPE=Ruby\u0000" +
      "BASENAME=rbhook\u0000" +
      "REASON=/foo/bar.rb:3:in `block in func': baz (RuntimeError)\u0000" +
      "BACKTRACE=/foo/bar.rb:3:in `block in func': baz (RuntimeError)\n" +
        "\tfrom /foo/bar.rb:2:in `each'\n" +
        "\tfrom /foo/bar.rb:2:in `func'\n" +
        "\tfrom /foo.rb:2:in `<main>'\u0000"
    end

    let(:abrt) do
      allow(ABRT).to receive(:syslog).and_return(syslog)
      allow(ABRT).to receive(:abrt_socket).and_return(nil)
      ABRT
    end

    let(:syslog) do
      double("syslog").as_null_object.tap do |syslog|
        allow(syslog).to receive(:err).with("%s", anything)
      end
    end

    let(:io) { StringIO.new }

    it "handles exceptions" do
      expect(abrt).to receive(:abrt_socket).and_return(io)
      expect(io).to receive(:read).and_return("HTTP/1.1 201 \r\n\r\n")
      expect(syslog).to_not receive(:err)

      abrt.handle_exception exception

      expect(io.string).to eq(exception_report)
    end

    it "logs unhandled exception message into syslog" do
      expect(syslog).to receive(:notice).with("detected unhandled Ruby exception in '/foo.rb'")
      abrt.handle_exception exception
    end

    it "ignores executables with relative path" do
      expect(abrt).to_not receive(:write_dump)

      exception.set_backtrace("./foo.rb:2:in `<main>'")

      abrt.handle_exception exception
    end

    it "ignores oneline scripts" do
      expect(abrt).to_not receive(:write_dump)

      exception.set_backtrace([
        "-e:1:in `/'",
        "-e:1:in `<main>'"
      ])

      abrt.handle_exception exception
    end

    context "logs error into syslog when" do
      it "receive empty response" do
        expect(abrt).to receive(:abrt_socket).and_return(io)
        expect(syslog).to receive(:err).with("error sending data to ABRT daemon. Empty response received")

        abrt.handle_exception exception
      end

      it "receive malformed response" do
        expect(abrt).to receive(:abrt_socket).and_return(io)
        expect(io).to receive(:read).and_return("foo")
        expect(syslog).to receive(:err).with("%s", "error sending data to ABRT daemon: foo")

        abrt.handle_exception exception
      end

      it "receive error code" do
        expect(abrt).to receive(:abrt_socket).and_return(io)
        expect(io).to receive(:read).and_return("HTTP/1.1 400 \r\n\r\n")
        expect(syslog).to receive(:err).with("%s", "error sending data to ABRT daemon: HTTP/1.1 400 \r\n\r\n")

        abrt.handle_exception exception
      end

      it "can't communicate with ABRT daemon" do
        expect(syslog).to receive(:err).with("%s", "can't communicate with ABRT daemon, is it running? undefined method `write' for nil:NilClass")
        abrt.handle_exception exception
      end
    end
  end
end
