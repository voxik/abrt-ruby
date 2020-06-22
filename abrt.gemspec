# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "abrt"
  s.version = "0.4.0"

  s.authors = ["Vít Ondruch"]
  s.email = "v.ondruch@tiscali.cz"

  s.summary = "ABRT support for Ruby."
  s.description = "Provides ABRT reporting support for libraries/applications written using Ruby."
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    Dir["lib/**/*"],
    Dir["config/*"],
  ].flatten
  s.homepage = "http://github.com/voxik/abrt-ruby"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  if File.exist? "~/.ssh/voxik-private_key.pem"
    s.signing_key = File.expand_path("~/.ssh/voxik-private_key.pem")
    s.cert_chain = ["voxik-public_cert.pem"]
  end

  s.add_development_dependency(%q<rspec>, ["~> 3.5"])
end

