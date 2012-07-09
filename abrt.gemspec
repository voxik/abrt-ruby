# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "abrt"
  s.version = "0.0.2"

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
  ].flatten
  s.homepage = "http://github.com/voxik/abrt-ruby"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]

  s.add_development_dependency(%q<rspec>, ["~> 2.8.0"])
end

