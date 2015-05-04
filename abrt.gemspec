# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "abrt"
  s.version = "0.1.1"

  s.authors = ["Vít Ondruch"]
  s.email = "v.ondruch@tiscali.cz"

  s.summary = "ABRT support for Ruby."
  s.description = "Provides ABRT reporting support for libraries/applications written using Ruby."
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    Dir["lib/**/*"],
    Dir["config/*"],
  ].flatten
  s.homepage = "http://github.com/voxik/abrt-ruby"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.signing_key = File.expand_path("~/.ssh/voxik-private_key.pem")
  s.cert_chain = ["voxik-public_cert.pem"]

  s.add_development_dependency(%q<rspec>, ["~> 2.8"])
end

