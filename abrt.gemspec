# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "abrt"
  s.version = "0.0.2"

  s.authors = ["Vít Ondruch"]
  s.email = "v.ondruch@tiscali.cz"
  s.summary = "ABRT support for Ruby MRI."
  s.description = "Provides ABRT reporting support for applications written using Ruby."
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

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, ["~> 2.8.0"])
    else
      s.add_dependency(%q<rspec>, ["~> 2.8.0"])
    end
  else
    s.add_dependency(%q<rspec>, ["~> 2.8.0"])
  end
end

